## @file
#  Platform description.
#
# Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
#
# This program and the accompanying materials are licensed and made available under
# the terms and conditions of the BSD License which accompanies this distribution.
# The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
##
[Defines]
  #
  # Set platform specific package/folder name, same as passed from PREBUILD script.
  # PLATFORM_PACKAGE would be the same as PLATFORM_NAME as well as package build folder
  # DEFINE only takes effect at R9 DSC and FDF.
  #
  DEFINE      PLATFORM_PACKAGE                = MinPlatformPkg
  DEFINE      PLATFORM_SI_PACKAGE             = KabylakeSiliconPkg
  DEFINE      PLATFORM_SI_BIN_PACKAGE         = KabylakeSiliconBinPkg
  DEFINE      PLATFORM_FSP_BIN_PACKAGE        = KabylakeFspBinPkg
  DEFINE      PLATFORM_BOARD_PACKAGE          = KabylakeOpenBoardPkg

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                       = MinCorePkg
  PLATFORM_GUID                       = 77468157-ABE9-4F58-807A-78C5E0933B9B
  PLATFORM_VERSION                    = 0.1
  DSC_SPECIFICATION                   = 0x00010005
  OUTPUT_DIRECTORY                    = Build/MinCorePkg
  SUPPORTED_ARCHITECTURES             = IA32|X64
  BUILD_TARGETS                       = DEBUG|RELEASE
  SKUID_IDENTIFIER                    = DEFAULT
  FLASH_DEFINITION                    = $(PLATFORM_PACKAGE)/MinCorePkg.fdf

  FIX_LOAD_TOP_MEMORY_ADDRESS         = 0x0
  DEFINE   TOP_MEMORY_ADDRESS         = 0x0

################################################################################
#
# SKU Identification section - list of all SKU IDs supported by this
#                              Platform.
#
################################################################################
[SkuIds]
  0|DEFAULT              # The entry: 0|DEFAULT is reserved and always required.

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################
[PcdsFixedAtBuild]
  gMinPlatformPkgTokenSpaceGuid.PcdBootStage|5

[PcdsFeatureFlag]
  gMinPlatformPkgTokenSpaceGuid.PcdSmiHandlerProfileEnable|FALSE
  gMinPlatformPkgTokenSpaceGuid.PcdUefiSecureBootEnable|FALSE
  gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable|FALSE
  gMinPlatformPkgTokenSpaceGuid.PcdPerformanceEnable|FALSE
  gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly|FALSE
  gAdvancedFeaturePkgTokenSpaceGuid.PcdNetworkEnable|TRUE
!if gMinPlatformPkgTokenSpaceGuid.PcdBootStage >= 5
  gMinPlatformPkgTokenSpaceGuid.PcdUefiSecureBootEnable|TRUE
  gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable|TRUE
!endif

!include $(PLATFORM_PACKAGE)/MinCorePcd.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreCommonLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeLib.dsc

[Components.IA32]
#
# Common
#
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiInclude.dsc
$(PLATFORM_PACKAGE)/HelloWorld/HelloWorld.inf

[Components.X64]
#
# Common
#
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeInclude.dsc
$(PLATFORM_PACKAGE)/HelloWorld/HelloWorld.inf
