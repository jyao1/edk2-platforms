/*++
  This file contains an 'Intel Peripheral Driver' and is
  licensed for Intel CPUs and chipsets under the terms of your
  license agreement with Intel or your vendor.  This file may
  be modified by the user, subject to additional terms of the
  license agreement
--*/
/** @file
  SerialPort PEIM to initialize serial port.

Copyright (c) 2006 - 2013, Intel Corporation. All rights reserved.<BR>
This software and associated documentation
(if any) is furnished under a license and may only be used or
copied in accordance with the terms of the license.  Except as
permitted by such license, no part of this software or
documentation may be reproduced, stored in a retrieval system, or
transmitted in any form or by any means without the express written
consent of Intel Corporation.

**/

#include <PiPei.h>

#include <Ppi/SerialPortPei.h>

#include <Library/PlatformHookLib.h>
#include <Library/PeiServicesLib.h>
#include <Library/DebugLib.h>

//
// Serial Port PPI
//
EFI_PEI_PPI_DESCRIPTOR mPpiSerialPort[] = {
  {
    (EFI_PEI_PPI_DESCRIPTOR_PPI | EFI_PEI_PPI_DESCRIPTOR_TERMINATE_LIST),
    &gPeiSerialPortPpiGuid,
    NULL
  }
};

EFI_STATUS
PeiSerialPortEntry (
  IN       EFI_PEI_FILE_HANDLE  FileHandle,
  IN CONST EFI_PEI_SERVICES     **PeiServices
  ) 
{
  EFI_STATUS Status;
  //
  // Initialize Serial Port. 
  //
  Status = PlatformHookSerialPortInitialize ();
  ASSERT_EFI_ERROR (Status);

  //
  // Install Serial Port PPI
  //
  return PeiServicesInstallPpi (&mPpiSerialPort[0]);
}

