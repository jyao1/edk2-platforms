/** @file
  Build FV related hobs for platform.

  Copyright (c) 2006 - 2013, Intel Corporation. All rights reserved.<BR>
  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include "PiPei.h"
#include "Platform.h"
#include <Library/DebugLib.h>
#include <Library/HobLib.h>
#include <Library/PeiServicesLib.h>
#include <Library/PcdLib.h>


/**
  Publish PEI & DXE (Decompressed) Memory based FVs to let PEI
  and DXE know about them.

  @retval EFI_SUCCESS   Platform PEI FVs were initialized successfully.

**/
EFI_STATUS
PeiFvInitialization (
  VOID
  )
{
  DEBUG ((EFI_D_INFO, "Platform PEI Firmware Volume Initialization\n"));

  BuildFvHob (PcdGet32 (PcdFlashFvUefiBootCoreBase), PcdGet32 (PcdFlashFvUefiBootCoreSize));
  PeiServicesInstallFvInfoPpi (
    NULL,
    (VOID *)(UINTN) PcdGet32 (PcdFlashFvUefiBootCoreBase),
    PcdGet32 (PcdFlashFvUefiBootCoreSize),
    NULL,
    NULL
    );

  BuildFvHob (PcdGet32 (PcdOvmfDxeFlashFvBase), PcdGet32 (PcdOvmfDxeFlashFvSize));
  PeiServicesInstallFvInfoPpi (
    NULL,
    (VOID *)(UINTN) PcdGet32 (PcdOvmfDxeFlashFvBase),
    PcdGet32 (PcdOvmfDxeFlashFvSize),
    NULL,
    NULL
    );

  return EFI_SUCCESS;
}

