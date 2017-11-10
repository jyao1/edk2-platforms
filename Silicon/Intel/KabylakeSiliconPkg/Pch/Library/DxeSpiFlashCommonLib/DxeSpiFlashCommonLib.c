/** @file
  DXE Library instance of SPI Flash Common Library Class

Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
This program and the accompanying materials are licensed and made available under
the terms and conditions of the BSD License that accompanies this distribution.
The full text of the license may be found at
http://opensource.org/licenses/bsd-license.php.

THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include <Library/SpiFlashCommonLib.h>

#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiRuntimeLib.h>
#include <Library/DxeServicesTableLib.h>
#include <Guid/EventGroup.h>
#include <Protocol/Spi.h>

extern PCH_SPI_PROTOCOL *mSpiProtocol;

//
// FlashAreaBaseAddress and Size for boottime and runtime usage.
//
extern UINTN mFlashAreaBaseAddress;
extern UINTN mFlashAreaSize;


/**
  The library constructuor.

  The function does the necessary initialization work for this library
  instance.

  @param[in]  ImageHandle       The firmware allocated handle for the UEFI image.
  @param[in]  SystemTable       A pointer to the EFI system table.

  @retval     EFI_SUCCESS       The function always return EFI_SUCCESS for now.
                                It will ASSERT on error for debug version.
  @retval     EFI_ERROR         Please reference LocateProtocol for error code details.
**/
EFI_STATUS
EFIAPI
DxeSpiFlashCommonLibConstructor (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS Status;

  mFlashAreaBaseAddress = (UINTN)PcdGet32 (PcdFlashAreaBaseAddress);
  mFlashAreaSize        = (UINTN)PcdGet32 (PcdFlashAreaSize);

  //
  // Locate the SPI protocol.
  //
  Status = gBS->LocateProtocol (
                  &gPchSpiProtocolGuid,
                  NULL,
                  (VOID **)&mSpiProtocol
                  );
  ASSERT_EFI_ERROR (Status);

  return Status;
}
