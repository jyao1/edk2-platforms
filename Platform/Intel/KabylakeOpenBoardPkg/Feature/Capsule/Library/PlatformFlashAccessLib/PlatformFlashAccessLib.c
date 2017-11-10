/** @file
  Platform Flash Access library.

  Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include <PiDxe.h>

#include <Library/BaseLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/CacheMaintenanceLib.h>
#include <Library/DebugLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/PcdLib.h>
#include <Library/PrintLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiLib.h>
#include <Library/PciLib.h>
#include <Library/SpiFlashCommonLib.h>
#include <Library/PlatformFlashAccessLib.h>

#define BLOCK_SIZE 0x1000
#define ALINGED_SIZE BLOCK_SIZE

EFI_PHYSICAL_ADDRESS  mInternalFdAddress;

/**

Routine Description:

  Erase the whole block.

Arguments:

  BaseAddress  - Base address of the block to be erased.

Returns:

  EFI_SUCCESS - The command completed successfully.
  Other       - Device error or wirte-locked, operation failed.

**/
EFI_STATUS
InternalEraseBlock (
  IN  EFI_PHYSICAL_ADDRESS BaseAddress
  )
{
  EFI_STATUS                              Status;
  UINTN                                   NumBytes;

  NumBytes = BLOCK_SIZE;

  Status = SpiFlashBlockErase ((UINTN) BaseAddress, &NumBytes);
  if (EFI_ERROR (Status)) {
    DEBUG((EFI_D_ERROR, "Flash erase error - %r\n", Status));
    return Status;
  }

  return Status;
}

EFI_STATUS
InternalReadBlock (
  IN  EFI_PHYSICAL_ADDRESS  BaseAddress,
  OUT VOID                  *ReadBuffer
  )
{
  EFI_STATUS    Status;
  UINT32        BlockSize;

  BlockSize = BLOCK_SIZE;

  Status = SpiFlashRead ((UINTN) BaseAddress, &BlockSize, ReadBuffer);
  if (EFI_ERROR (Status)) {
    DEBUG((EFI_D_ERROR, "Flash read error - %r\n", Status));
    return Status;
  }

  return Status;
}

EFI_STATUS
InternalCompareBlock (
  IN  EFI_PHYSICAL_ADDRESS        BaseAddress,
  IN  UINT8                       *Buffer
  )
{
  EFI_STATUS                              Status;
  VOID                                    *CompareBuffer;
  UINT32                                  NumBytes;
  INTN                                    CompareResult;

  NumBytes = BLOCK_SIZE;
  CompareBuffer = AllocatePool (NumBytes);
  if (CompareBuffer == NULL) {
    Status = EFI_OUT_OF_RESOURCES;
    goto Done;
  }

  Status = SpiFlashRead ((UINTN) BaseAddress, &NumBytes, CompareBuffer);
  if (EFI_ERROR (Status)) {
    goto Done;
  }
  CompareResult = CompareMem (CompareBuffer, Buffer, BLOCK_SIZE);
  if (CompareResult != 0) {
    Status = EFI_VOLUME_CORRUPTED;
  }

Done:
  if (CompareBuffer != NULL) {
    FreePool (CompareBuffer);
  }

  return Status;
}

/**

Routine Description:

  Write a block of data.

Arguments:

  BaseAddress  - Base address of the block.
  Buffer       - Data buffer.
  BufferSize   - Size of the buffer.

Returns:

  EFI_SUCCESS           - The command completed successfully.
  EFI_INVALID_PARAMETER - Invalid parameter, can not proceed.
  Other                 - Device error or wirte-locked, operation failed.

**/
EFI_STATUS
InternalWriteBlock (
  IN  EFI_PHYSICAL_ADDRESS        BaseAddress,
  IN  UINT8                       *Buffer,
  IN  UINT32                      BufferSize
  )
{
  EFI_STATUS                              Status;

  Status = SpiFlashWrite ((UINTN) BaseAddress, &BufferSize, Buffer);
  if (EFI_ERROR (Status)) {
    DEBUG((EFI_D_ERROR, "Flash write error - %r\n", Status));
    return Status;
  }

  WriteBackInvalidateDataCacheRange ((VOID *) (UINTN) BaseAddress, BLOCK_SIZE);

  Status = InternalCompareBlock (BaseAddress, Buffer);
  if (EFI_ERROR (Status)) {
    DEBUG((EFI_D_ERROR, "Error when writing to BaseAddress %lx with different at offset %x.\n", BaseAddress, Status));
  } else {
    DEBUG((DEBUG_INFO, "Verified data written to Block at %lx is correct.\n", BaseAddress));
  }

  return Status;
}

/**
  Perform flash write opreation.

  @param[in] FirmwareType      The type of firmware.
  @param[in] FlashAddress      The address of flash device to be accessed.
  @param[in] FlashAddressType  The type of flash device address.
  @param[in] Buffer            The pointer to the data buffer.
  @param[in] Length            The length of data buffer in bytes.

  @retval EFI_SUCCESS           The operation returns successfully.
  @retval EFI_WRITE_PROTECTED   The flash device is read only.
  @retval EFI_UNSUPPORTED       The flash device access is unsupported.
  @retval EFI_INVALID_PARAMETER The input parameter is not valid.
**/
EFI_STATUS
EFIAPI
PerformFlashWrite (
  IN PLATFORM_FIRMWARE_TYPE       FirmwareType,
  IN EFI_PHYSICAL_ADDRESS         FlashAddress,
  IN FLASH_ADDRESS_TYPE           FlashAddressType,
  IN VOID                         *Buffer,
  IN UINTN                        Length
  )
{
  EFI_STATUS            Status;
  UINTN                 Index;
  EFI_PHYSICAL_ADDRESS  Address;
  UINTN                 CountOfBlocks;
  EFI_TPL               OldTpl;
  BOOLEAN               FlashError;
  UINT8                 *Buf;

  Index             = 0;
  Address           = 0;
  CountOfBlocks     = 0;
  FlashError        = FALSE;
  Buf               = Buffer;

  DEBUG((DEBUG_INFO, "PerformFlashWrite - 0x%x(%x) - 0x%x\n", (UINTN)FlashAddress, (UINTN)FlashAddressType, Length));
  if (FlashAddressType == FlashAddressTypeRelativeAddress) {
    FlashAddress = FlashAddress + mInternalFdAddress;
  }
  DEBUG((DEBUG_INFO, "PerformFlashWrite Final address - 0x%x\n", (UINTN)FlashAddress));

  CountOfBlocks = (UINTN) (Length / BLOCK_SIZE);
  Address = FlashAddress;

  //
  // Raise TPL to TPL_NOTIFY to block any event handler,
  // while still allowing RaiseTPL(TPL_NOTIFY) within
  // output driver during Print()
  //
  OldTpl = gBS->RaiseTPL (TPL_NOTIFY);

  for (Index = 0; Index < CountOfBlocks; Index++) {
    //
    // Handle block based on address and contents.
    //
    if (!EFI_ERROR (InternalCompareBlock (Address, Buf))) {
      DEBUG ((DEBUG_INFO, "Skipping block at 0x%lx (already programmed)\n", Address));
    } else {
      //
      // Display a dot for each block being updated.
      //
      Print (L".");
      DEBUG ((DEBUG_INFO, "."));

      //
      // Make updating process uninterruptable,
      // so that the flash memory area is not accessed by other entities
      // which may interfere with the updating process
      //
      Status  = InternalEraseBlock (Address);
      if (EFI_ERROR (Status)) {
        DEBUG ((DEBUG_ERROR, "InternalEraseBlock(0x%lx) - %r\n", Address, Status));
        FlashError = TRUE;
        goto Done;
      }

      Status = InternalWriteBlock (
                 Address,
                 Buf,
                 (UINT32)(Length > BLOCK_SIZE ? BLOCK_SIZE : Length)
                 );
      if (EFI_ERROR (Status)) {
        DEBUG ((DEBUG_ERROR, "InternalWriteBlock(0x%lx) - %r\n", Address, Status));
        FlashError = TRUE;
        goto Done;
      }
    }

    //
    // Move to next block to update.
    //
    Address += BLOCK_SIZE;
    Buf += BLOCK_SIZE;
    if (Length > BLOCK_SIZE) {
      Length -= BLOCK_SIZE;
    } else {
      Length = 0;
    }
  }

Done:
  gBS->RestoreTPL (OldTpl);

  //
  // Print flash update failure message if error detected.
  //
  if (FlashError) {
    Print (L"ERROR: %r\n", Status);
    DEBUG ((DEBUG_ERROR, "ERROR: %r\n", Status));
  }

  return EFI_SUCCESS;
}

/**
  Platform Flash Access Lib Constructor.

  @param[in]  ImageHandle       The firmware allocated handle for the EFI image.
  @param[in]  SystemTable       A pointer to the EFI System Table.

  @retval EFI_SUCCESS  Constructor returns successfully.
**/
EFI_STATUS
EFIAPI
PerformFlashAccessLibConstructor (
  IN EFI_HANDLE                         ImageHandle,
  IN EFI_SYSTEM_TABLE                   *SystemTable
  )
{
  mInternalFdAddress = (EFI_PHYSICAL_ADDRESS)(UINTN)PcdGet32(PcdFlashAreaBaseAddress);
  DEBUG((DEBUG_INFO, "PcdFlashAreaBaseAddress - 0x%x\n", mInternalFdAddress));

  return EFI_SUCCESS;
}
