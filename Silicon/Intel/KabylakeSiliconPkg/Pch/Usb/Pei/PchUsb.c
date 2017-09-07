/**

  Pch Usb Pei Init

Copyright (c) 2009 Intel Corporation. All rights reserved
This software and associated documentation (if any) is furnished
under a license and may only be used or copied in accordance
with the terms of the license. Except as permitted by such
license, no part of this software or documentation may be
reproduced, stored in a retrieval system, or transmitted in any
form or by any means without the express written consent of
Intel Corporation.

**/

#include <PiPei.h>
#include <Library/DebugLib.h>
#include <Library/PeiServicesLib.h>

/**

  Initialize PCH XHCI PEIM

  PeiServices     General purpose services available to every PEIM.
  UsbPolicyPpi    Usb Host Controller Policy PPI

  EFI_SUCCESS     the PCH EHCI PEIM is initialized successfully
  All other error conditions encountered result in an ASSERT.

**/
EFI_STATUS
InitForXHCI (
  IN UINTN                      XhciMemBaseAddr,
  IN UINTN                      XhciMemLength
  );

/**
  Initialize PCH USB PEIM
  
  @param  FileHandle  Handle of the file being invoked.
  @param  PeiServices Describes the list of possible PEI Services.
  
  @retval EFI_SUCCESS            The PCH USB PEIM is initialized successfully.
  @retval EFI_OUT_OF_RESOURCES   Can't initialize the driver.
**/
EFI_STATUS
EFIAPI
InitializePchUsb (
  IN EFI_FFS_FILE_HEADER       *FfsHeader,
  IN CONST EFI_PEI_SERVICES    **PeiServices
  )
{
  EFI_STATUS          Status;
  UINTN               XhciMemBaseAddr;
  UINTN               XhciMemLength;

  DEBUG ((DEBUG_INFO, "InitializePchUsb() Start\n"));

  XhciMemBaseAddr = 0xFEA10000; // TBD - use PCD
  XhciMemLength   = 0x10000;

  //
  // Enable USB controller and install PeiUsbControllerPpi for USB recovery function
  //
  DEBUG ((DEBUG_INFO, "Usb Recovery Mode : XHCI !\n"));
  DEBUG ((DEBUG_INFO, "XhciMemBaseAddr:%0x!\n", XhciMemBaseAddr));
  DEBUG ((DEBUG_INFO, "XhciMemLength:%0x!\n", XhciMemLength));
  Status = InitForXHCI (XhciMemBaseAddr, XhciMemLength);

  DEBUG ((DEBUG_INFO, "InitializePchUsb() End\n"));

  return Status;
}