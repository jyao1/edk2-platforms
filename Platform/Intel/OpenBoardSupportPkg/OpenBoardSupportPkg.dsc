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
  PLATFORM_NAME                       = OpenBoardSupportPkg
  PLATFORM_GUID                       = D9A2335A-64F0-4961-8ADF-383F10D80251
  PLATFORM_VERSION                    = 0.1
  DSC_SPECIFICATION                   = 0x00010005
  OUTPUT_DIRECTORY                    = Build/OpenBoardSupportPkg
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

  #
  # Misc
  #
  FspWrapperApiLib|IntelFsp2WrapperPkg/Library/BaseFspWrapperApiLib/BaseFspWrapperApiLib.inf
  FspWrapperApiTestLib|IntelFsp2WrapperPkg/Library/PeiFspWrapperApiTestLib/PeiFspWrapperApiTestLib.inf
  FspWrapperHobProcessLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperHobProcessLib/PeiFspWrapperHobProcessLib.inf
  PlatformSecLib|OpenBoardSupportPkg/FspWrapper/Library/SecFspWrapperPlatformSecLib/SecFspWrapperPlatformSecLib.inf

  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf

  BoardInitLib|MinPlatformModulePkg/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  BoardAcpiTableLib|OpenBoardSupportPkg/Acpi/Library/BoardAcpiLibNull/BoardAcpiTableLibNull.inf
  BoardAcpiEnableLib|MinPlatformModulePkg/Acpi/Library/BoardAcpiLibNull/BoardAcpiEnableLibNull.inf


[LibraryClasses.common.SEC]

[LibraryClasses.common.PEIM]
  #
  # PEI phase common
  #
  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf

[LibraryClasses.common.DXE_DRIVER]
  #
  # DXE phase common
  #
  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/DxeFspWrapperPlatformLib/DxeFspWrapperPlatformLib.inf

[LibraryClasses.common.DXE_SMM_DRIVER]

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

  OpenBoardSupportPkg/Library/PeiLib/PeiLib.inf
  OpenBoardSupportPkg/Library/PeiHobVariableLibFce/PeiHobVariableLibFce.inf
  OpenBoardSupportPkg/Library/PeiHobVariableLibFce/PeiHobVariableLibFceOptSize.inf
  OpenBoardSupportPkg/Library/CompressLib/CompressLib.inf

  OpenBoardSupportPkg/Acpi/Library/BoardAcpiLibNull/BoardAcpiTableLibNull.inf
  OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiTableSupportLib/DxeMultiBoardAcpiTableSupportLib.inf
  OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiEnableSupportLib/SmmMultiBoardAcpiEnableSupportLib.inf

  OpenBoardSupportPkg/FspWrapper/SaveMemoryConfig/SaveMemoryConfig.inf
  OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperHobProcessLib/PeiFspWrapperHobProcessLib.inf
  OpenBoardSupportPkg/FspWrapper/Library/SecFspWrapperPlatformSecLib/SecFspWrapperPlatformSecLib.inf
  OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  OpenBoardSupportPkg/FspWrapper/Library/DxeFspWrapperPlatformLib/DxeFspWrapperPlatformLib.inf

  OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  OpenBoardSupportPkg/PlatformInit/ReportFv/ReportFv.inf

