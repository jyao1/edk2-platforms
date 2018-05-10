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
  DEFINE      PLATFORM_PACKAGE                = MinPlatformModulePkg
  DEFINE      PLATFORM_SI_PACKAGE             = KabylakeSiliconPkg
  DEFINE      PLATFORM_SI_BIN_PACKAGE         = KabylakeSiliconBinPkg
  DEFINE      PLATFORM_FSP_BIN_PACKAGE        = KabylakeFspBinPkg
  DEFINE      PLATFORM_BOARD_PACKAGE          = KabylakeOpenBoardPkg
  DEFINE      BOARD                           = KabylakeRvp3
  DEFINE      PROJECT                         = $(PLATFORM_BOARD_PACKAGE)/$(BOARD)

[PcdsFeatureFlag]
  #
  # Platform On/Off features are defined here
  #
  !include OpenBoardPkgConfig.dsc

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                       = $(PLATFORM_PACKAGE)
  PLATFORM_GUID                       = 465B0A0B-7AC1-443b-8F67-7B8DEC145F90
  PLATFORM_VERSION                    = 0.1
  DSC_SPECIFICATION                   = 0x00010005
  OUTPUT_DIRECTORY                    = Build/$(PROJECT)
  SUPPORTED_ARCHITECTURES             = IA32|X64
  BUILD_TARGETS                       = DEBUG|RELEASE
  SKUID_IDENTIFIER                    = ALL


  FLASH_DEFINITION                    = $(PROJECT)/OpenBoardPkg.fdf

  FIX_LOAD_TOP_MEMORY_ADDRESS         = 0x0
  DEFINE   TOP_MEMORY_ADDRESS         = 0x0

  #
  # Default value for OpenBoardPkg.fdf use
  #
  DEFINE BIOS_SIZE_OPTION = SIZE_70

################################################################################
#
# SKU Identification section - list of all SKU IDs supported by this
#                              Platform.
#
################################################################################
[SkuIds]
  0|DEFAULT              # The entry: 0|DEFAULT is reserved and always required.
  4|KabylakeRvp3
  0x60|KabyLakeYLpddr3Rvp3

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################

!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreCommonLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeLib.dsc

[LibraryClasses.common]

  PeiLib|OpenBoardSupportPkg/Library/PeiLib/PeiLib.inf

  PciHostBridgeLib|$(PLATFORM_PACKAGE)/Pci/Library/PciHostBridgeLibSimple/PciHostBridgeLibSimple.inf
  PciSegmentInfoLib|$(PLATFORM_PACKAGE)/Pci/Library/PciSegmentInfoLibSimple/PciSegmentInfoLibSimple.inf
  PlatformBootManagerLib|$(PLATFORM_PACKAGE)/Bds/Library/DxePlatformBootManagerLib/DxePlatformBootManagerLib.inf
  I2cAccessLib|$(PLATFORM_BOARD_PACKAGE)/Library/PeiI2cAccessLib/PeiI2cAccessLib.inf
  GpioExpanderLib|$(PLATFORM_BOARD_PACKAGE)/Library/BaseGpioExpanderLib/BaseGpioExpanderLib.inf

  PlatformHookLib|$(PROJECT)/Library/BasePlatformHookLib/BasePlatformHookLib.inf

  FspWrapperHobProcessLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperHobProcessLib/PeiFspWrapperHobProcessLib.inf
  PlatformSecLib|OpenBoardSupportPkg/FspWrapper/Library/SecFspWrapperPlatformSecLib/SecFspWrapperPlatformSecLib.inf
  
  FspWrapperApiLib|IntelFsp2WrapperPkg/Library/BaseFspWrapperApiLib/BaseFspWrapperApiLib.inf
  FspWrapperApiTestLib|IntelFsp2WrapperPkg/Library/PeiFspWrapperApiTestLib/PeiFspWrapperApiTestLib.inf

  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibFsp/PeiSiliconPolicyInitLibFsp.inf
  SiliconPolicyUpdateLib|$(PLATFORM_BOARD_PACKAGE)/FspWrapper/Library/PeiSiliconPolicyUpdateLibFsp/PeiSiliconPolicyUpdateLibFsp.inf

  ConfigBlockLib|$(PLATFORM_SI_PACKAGE)/Library/BaseConfigBlockLib/BaseConfigBlockLib.inf
  SiliconInitLib|$(PLATFORM_SI_PACKAGE)/Library/SiliconInitLib/SiliconInitLib.inf

  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLibNull/TestPointCheckLibNull.inf

# Tbt
!if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
  TbtCommonLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiDxeSmmTbtCommonLib/TbtCommonLib.inf
  DxeTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/DxeTbtPolicyLib/DxeTbtPolicyLib.inf
!endif
#
# Silicon Init Package
#
!include $(PLATFORM_SI_PACKAGE)/SiPkgCommonLib.dsc

[LibraryClasses.IA32]
  #
  # PEI phase common
  #
  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/PeiTestPointCheckLib.inf
!endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/PeiTestPointLib.inf
  MultiBoardInitSupportLib|OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  BoardInitLib|OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf

# Tbt
!if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
  PeiTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiTbtPolicyLib/PeiTbtPolicyLib.inf
  PeiDTbtInitLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/Private/PeiDTbtInitLib/PeiDTbtInitLib.inf
!endif
#
# Silicon Init Package
#
!include $(PLATFORM_SI_PACKAGE)/SiPkgPeiLib.dsc

[LibraryClasses.IA32.SEC]
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SecTestPointCheckLib.inf

[LibraryClasses.X64]
  #
  # DXE phase common
  #
  FspWrapperPlatformLib|OpenBoardSupportPkg/FspWrapper/Library/DxeFspWrapperPlatformLib/DxeFspWrapperPlatformLib.inf
!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/DxeTestPointCheckLib.inf
!endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/DxeTestPointLib.inf
  MultiBoardInitSupportLib|OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  BoardInitLib|OpenBoardSupportPkg/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  MultiBoardAcpiTableSupportLib|OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiTableSupportLib/DxeMultiBoardAcpiTableSupportLib.inf
  BoardAcpiTableLib|OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiTableSupportLib/DxeMultiBoardAcpiTableSupportLib.inf

  SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/DxeSiliconPolicyInitLib/DxeSiliconPolicyInitLib.inf
  SiliconPolicyUpdateLib|$(PLATFORM_BOARD_PACKAGE)/Policy/Library/DxeSiliconPolicyUpdateLib/DxeSiliconPolicyUpdateLib.inf

#
# Silicon Init Package
#
!include $(PLATFORM_SI_PACKAGE)/SiPkgDxeLib.dsc

[LibraryClasses.X64.DXE_SMM_DRIVER]
  SpiFlashCommonLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/SmmSpiFlashCommonLib/SmmSpiFlashCommonLib.inf
!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SmmTestPointCheckLib.inf
!endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/SmmTestPointLib.inf
  MultiBoardAcpiEnableSupportLib|OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiEnableSupportLib/SmmMultiBoardAcpiEnableSupportLib.inf
  BoardAcpiEnableLib|OpenBoardSupportPkg/Acpi/Library/MultiBoardAcpiEnableSupportLib/SmmMultiBoardAcpiEnableSupportLib.inf

[LibraryClasses.X64.DXE_RUNTIME_DRIVER]
  ResetSystemLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/DxeRuntimeResetSystemLib/DxeRuntimeResetSystemLib.inf

!include OpenBoardPkgPcd.dsc

[Components.IA32]

#
# Common
#
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiInclude.dsc

  #
  # FSP wrapper SEC Core
  #
  UefiCpuPkg/SecCore/SecCore.inf {
    <LibraryClasses>
      #PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
      PcdLib|MdePkg/Library/PeiPcdLib/PeiPcdLib.inf
  }
  
#
# Silicon
#
!include $(PLATFORM_SI_PACKAGE)/SiPkgPei.dsc

#
# Platform
#
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPreMem.inf {
    <LibraryClasses>
!if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
      BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPreMemLib.inf
!else
      NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPreMemLib.inf
!endif
  }
  OpenBoardSupportPkg/PlatformInit/ReportFv/ReportFv.inf
  IntelFsp2WrapperPkg/FspmWrapperPeim/FspmWrapperPeim.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibDependency/PeiPreMemSiliconPolicyInitLibDependency.inf
  }
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPreMem.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPostMem.inf {
    <LibraryClasses>
!if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
      BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPostMemLib.inf
!else
      NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPostMemLib.inf
!endif
  }

  IntelFsp2WrapperPkg/FspsWrapperPeim/FspsWrapperPeim.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibDependency/PeiPostMemSiliconPolicyInitLibDependency.inf
  }
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPostMem.inf

#
# Security
#

!if gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable == TRUE
  $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformPei/Tcg2PlatformPei.inf
!endif

  IntelSiliconPkg/Feature/VTd/IntelVTdPmrPei/IntelVTdPmrPei.inf
  IntelSiliconPkg/Feature/VTd/PlatformVTdInfoSamplePei/PlatformVTdInfoSamplePei.inf

# Tbt
!if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Pei/PeiTbtInit.inf
!endif

[Components.X64]

#
# Common
#
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeInclude.dsc
  
  UefiCpuPkg/CpuDxe/CpuDxe.inf
  MdeModulePkg/Bus/Pci/PciHostBridgeDxe/PciHostBridgeDxe.inf

  MdeModulePkg/Bus/Pci/SataControllerDxe/SataControllerDxe.inf
  MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
  MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
  MdeModulePkg/Universal/Console/GraphicsOutputDxe/GraphicsOutputDxe.inf

  ShellBinPkg/UefiShell/UefiShell.inf

#
# Silicon
#
!include $(PLATFORM_SI_PACKAGE)/SiPkgDxe.dsc

# Tbt
!if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Smm/TbtSmm.inf
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Dxe/TbtDxe.inf
  $(PLATFORM_BOARD_PACKAGE)/Features/PciHotPlug/PciHotPlug.inf
!endif

#
# Platform
#
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyDxe/SiliconPolicyDxe.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitDxe/PlatformInitDxe.inf
  IntelFsp2WrapperPkg/FspWrapperNotifyDxe/FspWrapperNotifyDxe.inf

  OpenBoardSupportPkg/FspWrapper/SaveMemoryConfig/SaveMemoryConfig.inf
  
  $(PLATFORM_PACKAGE)/Test/TestPointStubDxe/TestPointStubDxe.inf
  $(PLATFORM_PACKAGE)/Test/TestPointDumpApp/TestPointDumpApp.inf

#
# OS Boot
#
!if gMinPlatformModulePkgTokenSpaceGuid.PcdBootToShellOnly == FALSE
  $(PLATFORM_PACKAGE)/Acpi/AcpiTables/AcpiPlatform.inf
  $(PLATFORM_BOARD_PACKAGE)/Acpi/BoardAcpiDxe/BoardAcpiDxe.inf {
    <LibraryClasses>
!if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
      BoardAcpiTableLib|$(PROJECT)/Library/BoardAcpiLib/DxeBoardAcpiTableLib.inf
!else
      NULL|$(PROJECT)/Library/BoardAcpiLib/DxeMultiBoardAcpiTableSupportLib.inf
!endif
  }
  $(PLATFORM_PACKAGE)/Acpi/AcpiSmm/AcpiSmm.inf {
    <LibraryClasses>
!if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
      BoardAcpiEnableLib|$(PROJECT)/Library/BoardAcpiLib/SmmBoardAcpiEnableLib.inf
!else
      NULL|$(PROJECT)/Library/BoardAcpiLib/SmmMultiBoardAcpiEnableSupportLib.inf
!endif
  }

  $(PLATFORM_PACKAGE)/Flash/SpiFvbService/SpiFvbServiceSmm.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitSmm/PlatformInitSmm.inf

  UefiCpuPkg/PiSmmCpuDxeSmm/PiSmmCpuDxeSmm.inf

!endif

#
# Security
#
  $(PLATFORM_PACKAGE)/Hsti/HstiIbvPlatformDxe/HstiIbvPlatformDxe.inf

!if gMinPlatformModulePkgTokenSpaceGuid.PcdTpm2Enable == TRUE
  $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformDxe/Tcg2PlatformDxe.inf
!endif

  IntelSiliconPkg/Feature/VTd/IntelVTdDxe/IntelVTdDxe.inf

#
# Other
#
  $(PLATFORM_SI_BIN_PACKAGE)/Microcode/MicrocodeUpdates.inf

!include $(PLATFORM_SI_PACKAGE)/SiPkgBuildOption.dsc
!include OpenBoardPkgBuildOption.dsc