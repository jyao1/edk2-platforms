### @file
#
# Copyright (c) 2018, Intel Corporation. All rights reserved.<BR>
#
# This program and the accompanying materials are licensed and made available under
# the terms and conditions of the BSD License which accompanies this distribution.
# The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
###

#
# TRUE is ENABLE. FALSE is DISABLE.
#

  gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage|4
  
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterDebugInit|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterMemInit|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdBootToShellOnly|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdUefiSecureBootEnable|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable|FALSE

!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage >= 1
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterDebugInit|TRUE
!endif

!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage >= 2
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterDebugInit|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterMemInit|TRUE
!endif

!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage >= 3
  gMinPlatformModulePkgTokenSpaceGuid.PcdStopAfterMemInit|FALSE
  gMinPlatformModulePkgTokenSpaceGuid.PcdBootToShellOnly|TRUE
!endif

!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage >= 4
  gMinPlatformModulePkgTokenSpaceGuid.PcdBootToShellOnly|FALSE
!endif

!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootStage >= 5
  gMinPlatformModulePkgTokenSpaceGuid.PcdUefiSecureBootEnable|TRUE
  gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable|TRUE
!endif
  
  !if $(TARGET) == DEBUG
    gMinPlatformModulePkgTokenSpaceGuid.PcdSmiHandlerProfileEnable|TRUE
  !else
    gMinPlatformModulePkgTokenSpaceGuid.PcdSmiHandlerProfileEnable|FALSE
  !endif

  gMinPlatformModulePkgTokenSpaceGuid.PcdPerformanceEnable|TRUE

  gAdvancedFeaturePkgTokenSpaceGuid.PcdNetworkEnable|TRUE
  gAdvancedFeaturePkgTokenSpaceGuid.PcdSmbiosEnable|TRUE
  gAdvancedFeaturePkgTokenSpaceGuid.PcdIpmiEnable|TRUE

