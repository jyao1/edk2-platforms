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

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                       = MinPlatformModulePkg
  PLATFORM_GUID                       = D9A2335A-64F0-4961-8ADF-383F10D80251
  PLATFORM_VERSION                    = 0.1
  DSC_SPECIFICATION                   = 0x00010005
  OUTPUT_DIRECTORY                    = Build/MinPlatformModulePkg
  SUPPORTED_ARCHITECTURES             = IA32|X64
  BUILD_TARGETS                       = DEBUG|RELEASE
  SKUID_IDENTIFIER                    = DEFAULT

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
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################

[PcdsFeatureFlag]
  # configuration
    gMinPlatformModulePkgTokenSpaceGuid.PcdBootToShellOnly|FALSE
    gMinPlatformModulePkgTokenSpaceGuid.PcdUefiSecureBootEnable|FALSE
    gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable|FALSE
    gMinPlatformModulePkgTokenSpaceGuid.PcdPerformanceEnable|FALSE
    gMinPlatformModulePkgTokenSpaceGuid.PcdSmiHandlerProfileEnable|FALSE

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################

!include MinPlatformModulePkg/Include/Dsc/CoreCommonLib.dsc
!include MinPlatformModulePkg/Include/Dsc/CorePeiLib.dsc
!include MinPlatformModulePkg/Include/Dsc/CoreDxeLib.dsc

[LibraryClasses.common]
  #
  # Platform
  #
  PlatformHookLib|MdeModulePkg/Library/BasePlatformHookLibNull/BasePlatformHookLibNull.inf
  PciHostBridgeLib|MinPlatformModulePkg/Pci/Library/PciHostBridgeLibSimple/PciHostBridgeLibSimple.inf
  PciSegmentInfoLib|MinPlatformModulePkg/Pci/Library/PciSegmentInfoLibSimple/PciSegmentInfoLibSimple.inf
  PlatformBootManagerLib|MinPlatformModulePkg/Bds/Library/DxePlatformBootManagerLib/DxePlatformBootManagerLib.inf
  AslUpdateLib|MinPlatformModulePkg/Acpi/Library/DxeAslUpdateLib/DxeAslUpdateLib.inf

  #
  # Misc
  #

  BoardInitLib|MinPlatformModulePkg/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  BoardAcpiEnableLib|MinPlatformModulePkg/Acpi/Library/BoardAcpiLibNull/BoardAcpiEnableLibNull.inf
  SiliconPolicyInitLib|MinPlatformModulePkg/PlatformInit/Library/SiliconPolicyInitLibNull/SiliconPolicyInitLibNull.inf
  SiliconPolicyUpdateLib|MinPlatformModulePkg/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf

  TestPointCheckLib|MinPlatformModulePkg/Test/Library/TestPointCheckLibNull/TestPointCheckLibNull.inf

[LibraryClasses.common.SEC]
  TestPointCheckLib|MinPlatformModulePkg/Test/Library/TestPointCheckLib/SecTestPointCheckLib.inf

[LibraryClasses.common.PEIM]
  #
  # PEI phase common
  #
  TestPointCheckLib|MinPlatformModulePkg/Test/Library/TestPointCheckLib/PeiTestPointCheckLib.inf
  TestPointLib|MinPlatformModulePkg/Test/Library/TestPointLib/PeiTestPointLib.inf

[LibraryClasses.common.DXE_DRIVER]
  #
  # DXE phase common
  #
  TestPointCheckLib|MinPlatformModulePkg/Test/Library/TestPointCheckLib/DxeTestPointCheckLib.inf
  TestPointLib|MinPlatformModulePkg/Test/Library/TestPointLib/DxeTestPointLib.inf

[LibraryClasses.common.DXE_SMM_DRIVER]
  SpiFlashCommonLib|MinPlatformModulePkg/Flash/Library/SpiFlashCommonLibNull/SpiFlashCommonLibNull.inf
  TestPointCheckLib|MinPlatformModulePkg/Test/Library/TestPointCheckLib/SmmTestPointCheckLib.inf
  TestPointLib|MinPlatformModulePkg/Test/Library/TestPointLib/SmmTestPointLib.inf

###################################################################################################
#
# Components Section - list of the modules and components that will be processed by compilation
#                      tools and the EDK II tools to generate PE32/PE32+/Coff image files.
#
# Note: The EDK II DSC file is not used to specify how compiled binary images get placed
#       into firmware volume images. This section is just a list of modules to compile from
#       source into UEFI-compliant binaries.
#       It is the FDF file that contains information on combining binary files into firmware
#       volume images, whose concept is beyond UEFI and is described in PI specification.
#       Binary modules do not need to be listed in this section, as they should be
#       specified in the FDF file. For example: Shell binary (Shell_Full.efi), FAT binary (Fat.efi),
#       Logo (Logo.bmp), and etc.
#       There may also be modules listed in this section that are not required in the FDF file,
#       When a module listed here is excluded from FDF file, then UEFI-compliant binary will be
#       generated for it, but the binary will not be put into any firmware volume.
#
###################################################################################################

[Components]

  MinPlatformModulePkg/Acpi/AcpiTables/AcpiPlatform.inf
  MinPlatformModulePkg/Acpi/AcpiSmm/AcpiSmm.inf
  MinPlatformModulePkg/Acpi/Library/DxeAslUpdateLib/DxeAslUpdateLib.inf
  MinPlatformModulePkg/Acpi/Library/BoardAcpiLibNull/BoardAcpiEnableLibNull.inf

  MinPlatformModulePkg/Bds/Library/DxePlatformBootManagerLib/DxePlatformBootManagerLib.inf

  MinPlatformModulePkg/Flash/SpiFvbService/SpiFvbServiceSmm.inf
  MinPlatformModulePkg/Flash/Library/SpiFlashCommonLibNull/SpiFlashCommonLibNull.inf

  MinPlatformModulePkg/Hsti/HstiIbvPlatformDxe/HstiIbvPlatformDxe.inf

  MinPlatformModulePkg/Pci/Library/PciHostBridgeLibSimple/PciHostBridgeLibSimple.inf

  MinPlatformModulePkg/PlatformInit/PlatformInitPei/PlatformInitPreMem.inf
  MinPlatformModulePkg/PlatformInit/PlatformInitPei/PlatformInitPostMem.inf
  MinPlatformModulePkg/PlatformInit/PlatformInitDxe/PlatformInitDxe.inf
  MinPlatformModulePkg/PlatformInit/PlatformInitSmm/PlatformInitSmm.inf
  MinPlatformModulePkg/PlatformInit/Library/SecBoardInitLibNull/SecBoardInitLibNull.inf
  MinPlatformModulePkg/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  MinPlatformModulePkg/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPreMem.inf
  MinPlatformModulePkg/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPostMem.inf
  MinPlatformModulePkg/PlatformInit/SiliconPolicyDxe/SiliconPolicyDxe.inf
  MinPlatformModulePkg/PlatformInit/Library/SiliconPolicyInitLibNull/SiliconPolicyInitLibNull.inf
  MinPlatformModulePkg/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf

  MinPlatformModulePkg/Services/StallServicePei/StallServicePei.inf

  MinPlatformModulePkg/Test/Library/TestPointCheckLibNull/TestPointCheckLibNull.inf
  MinPlatformModulePkg/Test/Library/TestPointCheckLib/SecTestPointCheckLib.inf
  MinPlatformModulePkg/Test/Library/TestPointCheckLib/PeiTestPointCheckLib.inf
  MinPlatformModulePkg/Test/Library/TestPointCheckLib/DxeTestPointCheckLib.inf
  MinPlatformModulePkg/Test/Library/TestPointLib/DxeTestPointLib.inf
  MinPlatformModulePkg/Test/Library/TestPointLib/PeiTestPointLib.inf
  MinPlatformModulePkg/Test/Library/TestPointLib/SmmTestPointLib.inf
  MinPlatformModulePkg/Test/TestPointStubDxe/TestPointStubDxe.inf
  MinPlatformModulePkg/Test/TestPointDumpApp/TestPointDumpApp.inf

!if gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable == TRUE
  MinPlatformModulePkg/Tcg/Tcg2PlatformPei/Tcg2PlatformPei.inf
  MinPlatformModulePkg/Tcg/Tcg2PlatformDxe/Tcg2PlatformDxe.inf
!endif
