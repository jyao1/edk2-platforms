## @file
#  FDF include file that defines the main macros and sets the dependent PCDs.
#
#  Copyright (C) 2014, Red Hat, Inc.
#  Copyright (c) 2006 - 2013, Intel Corporation. All rights reserved.<BR>
#
#  This program and the accompanying materials are licensed and made available
#  under the terms and conditions of the BSD License which accompanies this
#  distribution. The full text of the license may be found at
#  http://opensource.org/licenses/bsd-license.php
#
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR
#  IMPLIED.
#
##

DEFINE BLOCK_SIZE        = 0x1000

DEFINE VARS_SIZE         = 0x84000
DEFINE VARS_BLOCKS       = 0x84
DEFINE VARS_LIVE_SIZE    = 0x40000
DEFINE VARS_SPARE_SIZE   = 0x42000

DEFINE FW_BASE_ADDRESS   = 0xFFC00000
DEFINE FW_SIZE           = 0x00400000
DEFINE FW_BLOCKS         = 0x400

DEFINE DXEFV_OFFSET      = 0x00084000
DEFINE DXEFV_SIZE        = 0x00068000
SET gMinPlatformPkgTokenSpaceGuid.PcdFlashFvUefiBootCoreOffset  = 0x000EC000
SET gMinPlatformPkgTokenSpaceGuid.PcdFlashFvUefiBootCoreSize    = 0x00298000
DEFINE PEIFV_OFFSET      = 0x00384000
DEFINE PEIFV_SIZE        = 0x00008000
SET gMinPlatformPkgTokenSpaceGuid.PcdFlashFvPreMemoryCoreOffset = 0x0038C000
SET gMinPlatformPkgTokenSpaceGuid.PcdFlashFvPreMemoryCoreSize   = 0x00040000
DEFINE SECFV_OFFSET      = 0x003CC000
DEFINE SECFV_SIZE        = 0x00034000


SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFdBaseAddress     = $(FW_BASE_ADDRESS)
SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFirmwareFdSize    = $(FW_SIZE)
SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFirmwareBlockSize = $(BLOCK_SIZE)

SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageVariableBase = $(FW_BASE_ADDRESS)
SET gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableSize = $(VARS_LIVE_SIZE)

SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageEventLogBase = gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageVariableBase + gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableSize
SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageEventLogSize = $(BLOCK_SIZE)

SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageFtwWorkingBase = gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageEventLogBase + gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageEventLogSize
SET gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingSize = $(BLOCK_SIZE)

SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageFtwSpareBase = gUefiOvmfPkgTokenSpaceGuid.PcdOvmfFlashNvStorageFtwWorkingBase + gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingSize
SET gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwSpareSize = $(VARS_SPARE_SIZE)

DEFINE MEMFD_BASE_ADDRESS = 0x800000

SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfSecPeiTempRamBase = $(MEMFD_BASE_ADDRESS) + 0x010000
SET gUefiOvmfPkgTokenSpaceGuid.PcdOvmfSecPeiTempRamSize = 0x010000
