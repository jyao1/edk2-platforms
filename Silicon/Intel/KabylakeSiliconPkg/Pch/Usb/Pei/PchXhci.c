/**
  Pch Xhci PPI Init

Copyright (c) 2017 Intel Corporation. All rights reserved
This software and associated documentation (if any) is furnished
under a license and may only be used or copied in accordance
with the terms of the license. Except as permitted by such
license, no part of this software or documentation may be
reproduced, stored in a retrieval system, or transmitted in any
form or by any means without the express written consent of
Intel Corporation.

**/

#include <PiPei.h>

//
// Driver Produced PPI Prototypes
//
#include <Ppi/UsbController.h>

//
// Driver Consumed PPI Prototypes
//

#include <Register/PchRegsUsb.h>
#include <IndustryStandard/Pci.h>
#include <Library/IoLib.h>
#include <Library/DebugLib.h>
#include <Library/PeiServicesLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/MmPciLib.h>

#define PEI_PCH_XHCI_SIGNATURE  SIGNATURE_32 ('X', 'H', 'C', 'I')
#define XHCI_MEMORY_SPACE       V_PCH_XHCI_MEM_LENGTH
#define PchXhciControllerMax    1

typedef struct {
  UINTN                   Signature;
  PEI_USB_CONTROLLER_PPI  XhciControllerPpi;
  EFI_PEI_PPI_DESCRIPTOR  PpiList;
  UINTN                   TotalXhciControllers;
  UINTN                   MemBase[PchXhciControllerMax];
} PCH_XHCI_DEVICE;

#define PCH_XHCI_DEVICE_FROM_THIS(a)  CR (a, PCH_XHCI_DEVICE, XhciControllerPpi, PEI_PCH_XHCI_SIGNATURE)


//
// PPI interface function
//
STATIC
EFI_STATUS
EFIAPI
GetXhciController (
  IN  EFI_PEI_SERVICES                **PeiServices,
  IN  PEI_USB_CONTROLLER_PPI          *This,
  IN  UINT8                           UsbControllerId,
  OUT UINTN                           *ControllerType,
  OUT UINTN                           *BaseAddress
  );

//
// Globals
//
STATIC PEI_USB_CONTROLLER_PPI   mXhciControllerPpi = { GetXhciController };

STATIC EFI_PEI_PPI_DESCRIPTOR   mXhciPpiList = {
  (EFI_PEI_PPI_DESCRIPTOR_PPI | EFI_PEI_PPI_DESCRIPTOR_TERMINATE_LIST),
  &gPeiUsbControllerPpiGuid,
  NULL
};

//
// Helper function
//
STATIC
EFI_STATUS
EnableXhciController (
  IN PCH_XHCI_DEVICE          *PeiPchXhciDev,
  IN UINT8                    UsbControllerId
  );

/**
  Initialize PCH Xhci PEIM
  
  @retval EFI_SUCCESS            The PCH Xhci PEIM is initialized successfully.
  @retval EFI_OUT_OF_RESOURCES   Can't initialize the driver.
**/
EFI_STATUS
InitForXHCI (
  IN UINTN                      XhciMemBaseAddr,
  IN UINTN                      XhciMemLength
  )
{
  EFI_STATUS            Status;
  UINTN                 Index;
  PCH_XHCI_DEVICE       *PeiPchXhciDev;
  EFI_BOOT_MODE         BootMode;

  DEBUG ((DEBUG_INFO, "InitForXHCI() Start\n"));

  Status = PeiServicesGetBootMode (&BootMode);

  //
  // We do not export this in S3 boot path, because it is only for recovery.
  //
  if (BootMode == BOOT_ON_S3_RESUME) {
    return EFI_SUCCESS;
  }

  PeiPchXhciDev = (PCH_XHCI_DEVICE *) AllocatePool (sizeof (PCH_XHCI_DEVICE));
  if (PeiPchXhciDev == NULL) {
    DEBUG ((EFI_D_ERROR, "Failed to allocate memory for PeiPchXhciDev! \n"));
    return EFI_OUT_OF_RESOURCES;
  }
  
  PeiPchXhciDev->Signature            = PEI_PCH_XHCI_SIGNATURE;
  PeiPchXhciDev->XhciControllerPpi    = mXhciControllerPpi;
  PeiPchXhciDev->PpiList              = mXhciPpiList;
  PeiPchXhciDev->PpiList.Ppi          = &PeiPchXhciDev->XhciControllerPpi;

  PeiPchXhciDev->TotalXhciControllers = PchXhciControllerMax;

  //
  // Assign resources and enable Xhci controllers
  //
  if (XhciMemLength < (XHCI_MEMORY_SPACE * PeiPchXhciDev->TotalXhciControllers)) {
    DEBUG ((EFI_D_ERROR, "The XhciMemLength is less than the required (%0x) !\n", (XHCI_MEMORY_SPACE * PeiPchXhciDev->TotalXhciControllers)));
    return EFI_INVALID_PARAMETER;
  }

  for (Index = 0; Index < PeiPchXhciDev->TotalXhciControllers; Index++) {
    PeiPchXhciDev->MemBase[Index] = XhciMemBaseAddr + XHCI_MEMORY_SPACE * Index;
    Status                        = EnableXhciController (PeiPchXhciDev, (UINT8) Index);
    ASSERT_EFI_ERROR (Status);
  }
  //
  // Install USB Controller PPI
  //
  Status = PeiServicesInstallPpi (&PeiPchXhciDev->PpiList);
  ASSERT_EFI_ERROR (Status);

  DEBUG ((DEBUG_INFO, "InitForXhci() End\n"));

  return Status;

}

//
// PPI interface implementation
//

/**

  Get Xhci controller information

  PeiServices         General PEI services
  This                Pointer to the PEI_Xhci_CONTROLLER_PPI
  UsbControllerId     The USB controller number
  ControllerType      Output: USB controller type
  BaseAddress         Output: Xhci controller memory base address

  EFI_INVALID_PARAMETER   UsbControllerId is out of range
  EFI_SUCCESS             Function completes successfully

--*/
STATIC
EFI_STATUS
EFIAPI
GetXhciController (
  IN  EFI_PEI_SERVICES                **PeiServices,
  IN  PEI_USB_CONTROLLER_PPI          *This,
  IN  UINT8                           UsbControllerId,
  OUT UINTN                           *ControllerType,
  OUT UINTN                           *BaseAddress
  )
{
  PCH_XHCI_DEVICE *PeiPchXhciDev;

  PeiPchXhciDev = PCH_XHCI_DEVICE_FROM_THIS (This);

  if (UsbControllerId >= PeiPchXhciDev->TotalXhciControllers) {
    return EFI_INVALID_PARAMETER;
  }

  *ControllerType = PEI_XHCI_CONTROLLER;

  *BaseAddress = PeiPchXhciDev->MemBase[UsbControllerId];

  return EFI_SUCCESS;
}

/**

  Enable the Xhci controller

  PeiServices             The general PEI services
  PeiPchXhciDev           The Xhci device
  UsbControllerId         The USB Controller number

  EFI_INVALID_PARAMETER   UsbControllerId is out of range
  EFI_SUCCESS             The function completes successfully

**/
STATIC
EFI_STATUS
EnableXhciController (
  IN PCH_XHCI_DEVICE          *PeiPchXhciDev,
  IN UINT8                    UsbControllerId
  )
{
  UINTN       BaseAddress;
  UINTN       XhciAddress;

  if (UsbControllerId >= PeiPchXhciDev->TotalXhciControllers) {
    return EFI_INVALID_PARAMETER;
  }

  BaseAddress = PeiPchXhciDev->MemBase[UsbControllerId];

  XhciAddress = MmPciBase (
                      PCI_BUS_NUMBER_PCH_XHCI,
                      PCI_DEVICE_NUMBER_PCH_XHCI,
                      PCI_FUNCTION_NUMBER_PCH_XHCI
                      );

  //
  // Assign base address register
  //
  MmioWrite32 (XhciAddress + R_PCH_XHCI_MEM_BASE, BaseAddress);
  MmioWrite32 (XhciAddress + R_PCH_XHCI_MEM_BASE_2, 0);

  //
  // Enable PCH XHCI register
  //
  MmioOr16 (
    (XhciAddress + PCI_COMMAND_OFFSET),
    (UINT16) (EFI_PCI_COMMAND_BUS_MASTER | EFI_PCI_COMMAND_MEMORY_SPACE)
    );

  return EFI_SUCCESS;
}
