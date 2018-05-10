/** @file
  Source code file for Platform Init Pre-Memory PEI module

Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
This program and the accompanying materials are licensed and made available under
the terms and conditions of the BSD License that accompanies this distribution.
The full text of the license may be found at
http://opensource.org/licenses/bsd-license.php.

THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include <Base.h>
#include <Library/DebugLib.h>
#include <Library/HobLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/PeiServicesLib.h>
#include <Ppi/FirmwareVolumeInfo.h>
#include <Guid/FirmwareFileSystem2.h>
#include <Library/PeiServicesTablePointerLib.h>
#include <Library/TestPointCheckLib.h>

EFI_STATUS
EFIAPI
MemoryDiscoveredPpiNotifyCallback (
  IN CONST EFI_PEI_SERVICES      **PeiServices,
  IN EFI_PEI_NOTIFY_DESCRIPTOR   *NotifyDescriptor,
  IN VOID                        *Ppi
  );

static EFI_PEI_NOTIFY_DESCRIPTOR mMemDiscoveredNotifyList = {
  (EFI_PEI_PPI_DESCRIPTOR_NOTIFY_CALLBACK | EFI_PEI_PPI_DESCRIPTOR_TERMINATE_LIST),
  &gEfiPeiMemoryDiscoveredPpiGuid,
  (EFI_PEIM_NOTIFY_ENTRY_POINT) MemoryDiscoveredPpiNotifyCallback
};

VOID
ReportPreMemFv (
  VOID
  )
{
  if (!PcdGetBool(PcdFspWrapperBootMode)) {
    DEBUG ((DEBUG_INFO, "Install FlashFvFspM - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvFspMBase), PcdGet32 (PcdFlashFvFspMSize)));
    PeiServicesInstallFvInfo2Ppi (
      &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvFspMBase))->FileSystemGuid),
      (VOID *) (UINTN) PcdGet32 (PcdFlashFvFspMBase),
      PcdGet32 (PcdFlashFvFspMSize),
      NULL,
      NULL,
      0
      );
  }
  DEBUG ((DEBUG_INFO, "Install FlashFvSecurity - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvSecurityBase), PcdGet32 (PcdFlashFvSecuritySize)));
  PeiServicesInstallFvInfo2Ppi (
    &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvSecurityBase))->FileSystemGuid),
    (VOID *) (UINTN) PcdGet32 (PcdFlashFvSecurityBase),
    PcdGet32 (PcdFlashFvSecuritySize),
    NULL,
    NULL,
    0
    );
  DEBUG ((DEBUG_INFO, "Install FlashFvAdvanced - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvAdvancedBase), PcdGet32 (PcdFlashFvAdvancedSize)));
  PeiServicesInstallFvInfo2Ppi (
    &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvAdvancedBase))->FileSystemGuid),
    (VOID *) (UINTN) PcdGet32 (PcdFlashFvAdvancedBase),
    PcdGet32 (PcdFlashFvAdvancedSize),
    NULL,
    NULL,
    0
    );
}

VOID
ReportPostMemFv (
  VOID
  )
{
  EFI_STATUS                    Status;
  EFI_BOOT_MODE                 BootMode;

  Status = PeiServicesGetBootMode (&BootMode);
  ASSERT_EFI_ERROR (Status);

  ///
  /// Build HOB for DXE
  ///
  if (BootMode == BOOT_IN_RECOVERY_MODE) {
    ///
    /// Prepare the recovery service
    ///
  } else {
    DEBUG ((DEBUG_INFO, "Install FlashFvPostMemory - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvPostMemoryBase), PcdGet32 (PcdFlashFvPostMemorySize)));
    PeiServicesInstallFvInfo2Ppi (
      &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvPostMemoryBase))->FileSystemGuid),
      (VOID *) (UINTN) PcdGet32 (PcdFlashFvPostMemoryBase),
      PcdGet32 (PcdFlashFvPostMemorySize),
      NULL,
      NULL,
      0
      );
    if (!PcdGetBool(PcdFspWrapperBootMode)) {
      DEBUG ((DEBUG_INFO, "Install FlashFvFspS - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvFspSBase), PcdGet32 (PcdFlashFvFspSSize)));
      PeiServicesInstallFvInfo2Ppi (
        &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvFspSBase))->FileSystemGuid),
        (VOID *) (UINTN) PcdGet32 (PcdFlashFvFspSBase),
        PcdGet32 (PcdFlashFvFspSSize),
        NULL,
        NULL,
        0
        );
      DEBUG ((DEBUG_INFO, "Install FlashFvFspU - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvFspUBase), PcdGet32 (PcdFlashFvFspUSize)));
      PeiServicesInstallFvInfo2Ppi (
        &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvFspUBase))->FileSystemGuid),
        (VOID *) (UINTN) PcdGet32 (PcdFlashFvFspUBase),
        PcdGet32 (PcdFlashFvFspUSize),
        NULL,
        NULL,
        0
        );
    }
    DEBUG ((DEBUG_INFO, "Install FlashFvUefiBoot - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvUefiBootBase), PcdGet32 (PcdFlashFvUefiBootSize)));
    PeiServicesInstallFvInfo2Ppi (
      &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvUefiBootBase))->FileSystemGuid),
      (VOID *) (UINTN) PcdGet32 (PcdFlashFvUefiBootBase),
      PcdGet32 (PcdFlashFvUefiBootSize),
      NULL,
      NULL,
      0
      );
    DEBUG ((DEBUG_INFO, "Install FlashFvOsBoot - 0x%x, 0x%x\n", PcdGet32 (PcdFlashFvOsBootBase), PcdGet32 (PcdFlashFvOsBootSize)));
    PeiServicesInstallFvInfo2Ppi (
      &(((EFI_FIRMWARE_VOLUME_HEADER *) (UINTN) PcdGet32 (PcdFlashFvOsBootBase))->FileSystemGuid),
      (VOID *) (UINTN) PcdGet32 (PcdFlashFvOsBootBase),
      PcdGet32 (PcdFlashFvOsBootSize),
      NULL,
      NULL,
      0
      );
  }

  //
  // Report resource HOB for flash FV
  //
  BuildResourceDescriptorHob (
    EFI_RESOURCE_MEMORY_MAPPED_IO,
    (EFI_RESOURCE_ATTRIBUTE_PRESENT    |
    EFI_RESOURCE_ATTRIBUTE_INITIALIZED |
    EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE),
    (UINTN) PcdGet32 (PcdFlashAreaBaseAddress),
    (UINTN) PcdGet32 (PcdFlashAreaSize)
    );
  BuildMemoryAllocationHob (
    (UINTN) PcdGet32 (PcdFlashAreaBaseAddress),
    (UINTN) PcdGet32 (PcdFlashAreaSize),
    EfiMemoryMappedIO
    );
}

/**
  Install Firmware Volume Hob's once there is main memory

  @param[in]  PeiServices       General purpose services available to every PEIM.
  @param[in]  NotifyDescriptor  Notify that this module published.
  @param[in]  Ppi               PPI that was installed.

  @retval     EFI_SUCCESS       The function completed successfully.
**/
EFI_STATUS
EFIAPI
MemoryDiscoveredPpiNotifyCallback (
  IN CONST EFI_PEI_SERVICES     **PeiServices,
  IN EFI_PEI_NOTIFY_DESCRIPTOR  *NotifyDescriptor,
  IN VOID                       *Ppi
  )
{
  ReportPostMemFv ();

  TestPointMemoryDiscoveredFvInfoFunctional ();

  return EFI_SUCCESS;
}

/**
  Platform Init before memory PEI module entry point

  @param[in]  FileHandle           Not used.
  @param[in]  PeiServices          General purpose services available to every PEIM.

  @retval     EFI_SUCCESS          The function completes successfully
  @retval     EFI_OUT_OF_RESOURCES Insufficient resources to create database
**/
EFI_STATUS
EFIAPI
ReportFvEntryPoint (
  IN       EFI_PEI_FILE_HANDLE  FileHandle,
  IN CONST EFI_PEI_SERVICES     **PeiServices
  )
{
  EFI_STATUS Status;

  ReportPreMemFv ();

  ///
  /// After code reorangized, memorycallback will run because the PPI is already
  /// installed when code run to here, it is supposed that the InstallEfiMemory is
  /// done before.
  ///
  Status = PeiServicesNotifyPpi (&mMemDiscoveredNotifyList);

  return Status;
}
