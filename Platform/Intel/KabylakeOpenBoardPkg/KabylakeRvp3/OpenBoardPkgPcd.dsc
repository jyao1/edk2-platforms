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
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################
[PcdsFeatureFlag.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdFrameworkCompatibilitySupport|TRUE
  gUefiCpuPkgTokenSpaceGuid.PcdCpuSmmEnableBspElection|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdPeiCoreImageLoaderSearchTeSectionFirst|FALSE
!if $(TARGET) == RELEASE
  gEfiMdeModulePkgTokenSpaceGuid.PcdStatusCodeUseSerial|FALSE
!else
  gEfiMdeModulePkgTokenSpaceGuid.PcdStatusCodeUseSerial|TRUE
!endif
  gEfiMdeModulePkgTokenSpaceGuid.PcdStatusCodeUseMemory|FALSE

  gUefiCpuPkgTokenSpaceGuid.PcdCpuSmmProfileEnable|FALSE

  gEfiMdeModulePkgTokenSpaceGuid.PcdInstallAcpiSdtProtocol|TRUE

[PcdsFixedAtBuild.common]
!if gMinPlatformModuleTokenSpaceGuid.PcdPerformanceEnable == TRUE
  gEfiMdePkgTokenSpaceGuid.PcdPerformanceLibraryPropertyMask|0x1
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxPeiPerformanceLogEntries|140
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdSmiHandlerProfileEnable == TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmiHandlerProfilePropertyMask|0x1
!endif

  gEfiMdePkgTokenSpaceGuid.PcdPciExpressBaseAddress|0xE0000000
  gSiPkgTokenSpaceGuid.PcdPciExpressRegionLength|0x10000000
  gSiPkgTokenSpaceGuid.PcdTemporaryRamBase|0xFEF80000
  gSiPkgTokenSpaceGuid.PcdTemporaryRamSize|0x00040000
  gIntelFsp2PkgTokenSpaceGuid.PcdTemporaryRamBase|0xFEF00000
  gIntelFsp2PkgTokenSpaceGuid.PcdTemporaryRamSize|0x00040000

  gIntelFsp2PkgTokenSpaceGuid.PcdFspTemporaryRamSize        | 0x00026000

  gSiPkgTokenSpaceGuid.PcdPeiTemporaryRamStackSize|0x20000
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxVariableSize|0x5000
  gEfiMdeModulePkgTokenSpaceGuid.PcdHwErrStorageSize|0x00000800
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxHardwareErrorVariableSize|0x400
  gEfiMdeModulePkgTokenSpaceGuid.PcdPeiCoreMaxFvSupported|30

  gEfiMdeModulePkgTokenSpaceGuid.PcdPeiCoreMaxPeimPerFv|60


  gEfiMdeModulePkgTokenSpaceGuid.PcdSrIovSupport|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdAriSupport|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdPeiCoreMaxPpiSupported|128
  gUefiCpuPkgTokenSpaceGuid.PcdCpuSmmApSyncTimeout|10000
!if $(TARGET) == RELEASE
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x0
  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x3
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2F
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialUseHardwareFlowControl|FALSE
  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x07
!endif
  gEfiMdeModulePkgTokenSpaceGuid.PcdLoadModuleAtFixAddressEnable|$(TOP_MEMORY_ADDRESS)
  gEfiMdeModulePkgTokenSpaceGuid.PcdBrowserSubtitleTextColor|0x0
  gEfiMdeModulePkgTokenSpaceGuid.PcdBrowserFieldTextColor|0x01
  gUefiCpuPkgTokenSpaceGuid.PcdCpuSmmStackSize|0x20000




gEfiMdeModulePkgTokenSpaceGuid.PcdReclaimVariableSpaceAtEndOfDxe|TRUE

#
# 8MB Default
#
gSiPkgTokenSpaceGuid.PcdTsegSize|0x800000

#
# 16MB TSEG in Debug build only.
#
!if $(TARGET) == DEBUG
  gSiPkgTokenSpaceGuid.PcdTsegSize|0x1000000
!endif



  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPciBusNumber|0x0
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPciDeviceNumber|0x1F
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPciFunctionNumber|0x2
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPciEnableRegisterOffset|0x44
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoBarEnableMask|0x80
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPciBarRegisterOffset|0x40
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPortBaseAddress|0x1800
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiPm1TmrOffset|0x08
  gPcAtChipsetPkgTokenSpaceGuid.PcdAcpiIoPortBaseAddressMask|0xFFFC

  !if $(TARGET) == RELEASE
  gMinPlatformModuleTokenSpaceGuid.PcdPlatformEfiReservedMemorySize|0x402
  !else
  gMinPlatformModuleTokenSpaceGuid.PcdPlatformEfiReservedMemorySize|0x188B
  !endif


  gMinPlatformModuleTokenSpaceGuid.PcdPlatformEfiRtDataMemorySize|0x4b
  !if $(TARGET) == RELEASE
  gMinPlatformModuleTokenSpaceGuid.PcdPlatformEfiRtCodeMemorySize|0x70
  !else
  gMinPlatformModuleTokenSpaceGuid.PcdPlatformEfiRtCodeMemorySize|0xE0
  !endif

  gIntelFsp2WrapperTokenSpaceGuid.PcdFsptBaseAddress|0xFFEBC000
  gIntelFsp2WrapperTokenSpaceGuid.PcdFspmBaseAddress|0xFFE00000

  ## Specifies max supported number of Logical Processors.
  # @Prompt Configure max supported number of Logical Processorss
  gUefiCpuPkgTokenSpaceGuid.PcdCpuMaxLogicalProcessorNumber|12

  ## Specifies the size of the microcode Region.
  # @Prompt Microcode Region size.
  gUefiCpuPkgTokenSpaceGuid.PcdCpuMicrocodePatchRegionSize|0

  ## Specifies timeout value in microseconds for the BSP to detect all APs for the first time.
  # @Prompt Timeout for the BSP to detect all APs for the first time.
  gUefiCpuPkgTokenSpaceGuid.PcdCpuApInitTimeOutInMicroSeconds|1000

  ## Specifies the AP wait loop state during POST phase.
  #  The value is defined as below.
  #  1: Place AP in the Hlt-Loop state.
  #  2: Place AP in the Mwait-Loop state.
  #  3: Place AP in the Run-Loop state.
  # @Prompt The AP wait loop state.
  gUefiCpuPkgTokenSpaceGuid.PcdCpuApLoopMode|2


  #
  # The PCDs are used to control the Windows SMM Security Mitigations Table - Protection Flags
  #
  # BIT0: If set, expresses that for all synchronous SMM entries,SMM will validate that input and output buffers lie entirely within the expected fixed memory regions.
  # BIT1: If set, expresses that for all synchronous SMM entries, SMM will validate that input and output pointers embedded within the fixed communication buffer only refer to address ranges \
  #       that lie entirely within the expected fixed memory regions.
  # BIT2: Firmware setting this bit is an indication that it will not allow reconfiguration of system resources via non-architectural mechanisms.
  # BIT3-31: Reserved
  #
  gMinPlatformModuleTokenSpaceGuid.PcdWsmtProtectionFlags|0x07

  #
  # See HstiFeatureBit.h for the definition
  #
  gSiPkgTokenSpaceGuid.PcdHstiIhvFeature1|0xF2
  gSiPkgTokenSpaceGuid.PcdHstiIhvFeature2|0x07

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage == 1
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage == 2
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage == 3
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x07, 0x03, 0x05, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage == 4
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x07, 0x03, 0x05, 0x1F, 0x00, 0x0F, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage == 5
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x0F, 0x07, 0x1F, 0x1F, 0x0F, 0x0F, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

!if gMinPlatformModuleTokenSpaceGuid.PcdBootStage >= 6
  gMinPlatformModuleTokenSpaceGuid.PcdTestPointIbvPlatformFeature|{0x03, 0x0F, 0x07, 0x1F, 0x1F, 0x0F, 0x0F, 0x07, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
!endif

[PcdsFixedAtBuild.IA32]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVpdBaseAddress|0x0
  gIntelFsp2PkgTokenSpaceGuid.PcdGlobalDataPointerAddress|0xFED00148
  gMinPlatformModuleTokenSpaceGuid.PcdPeiPhaseStackTop|0xA0000
  gIntelFsp2WrapperTokenSpaceGuid.PcdPeiMinMemSize|0x3800000

[PcdsFixedAtBuild.X64]
  gPcAtChipsetPkgTokenSpaceGuid.Pcd8259LegacyModeMask|0x0eB8


  # Default platform supported RFC 4646 languages: (American) English
  gEfiMdePkgTokenSpaceGuid.PcdUefiVariableDefaultPlatformLangCodes|"en-US"


[PcdsPatchableInModule.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosVersion|0x0208

  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000046

!if $(TARGET) == DEBUG
  gSiPkgTokenSpaceGuid.PcdSerialIoUartDebugEnable|1
!endif

[PcdsDynamicHii.X64.DEFAULT]
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|L"Timeout"|gEfiGlobalVariableGuid|0x0|5 # Variable: L"Timeout"
  gEfiMdePkgTokenSpaceGuid.PcdHardwareErrorRecordLevel|L"HwErrRecSupport"|gEfiGlobalVariableGuid|0x0|1 # Variable: L"HwErrRecSupport"

!if gMinPlatformModuleTokenSpaceGuid.PcdPerformanceEnable == TRUE
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|L"Timeout"|gEfiGlobalVariableGuid|0x0|1 # Variable: L"Timeout"
!endif

[PcdsDynamicDefault]
  gIntelFsp2WrapperTokenSpaceGuid.PcdFspsBaseAddress|0xFFDA0000

[PcdsDynamicDefault.common.DEFAULT]
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutColumn|0x0
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutRow|0x0
  gEfiMdeModulePkgTokenSpaceGuid.PcdAtaSmartEnable|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdConInConnectOnDemand|FALSE
  #
  #  Set video to native resolution as Windows 8 WHCK requirement.
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|0x0
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|0x0
  
  gEfiMdeModulePkgTokenSpaceGuid.PcdS3BootScriptTablePrivateDataPtr|0x0

[PcdsDynamicDefault.common.DEFAULT]
  # gEfiTpmDeviceInstanceTpm20DtpmGuid
  gEfiSecurityPkgTokenSpaceGuid.PcdTpmInstanceGuid|{0x5a, 0xf2, 0x6b, 0x28, 0xc3, 0xc2, 0x8c, 0x40, 0xb3, 0xb4, 0x25, 0xe6, 0x75, 0x8b, 0x73, 0x17}
  gEfiSecurityPkgTokenSpaceGuid.PcdTcg2HashAlgorithmBitmap|0
  gEfiSecurityPkgTokenSpaceGuid.PcdTpm2HashMask|0x0000001F
  gEfiSecurityPkgTokenSpaceGuid.PcdTpmInitializationPolicy|1
  
[PcdsDynamicExDefault.common.DEFAULT]
!if gMinPlatformModuleTokenSpaceGuid.PcdCapsuleUpdateEnable == TRUE
  gEfiSignedCapsulePkgTokenSpaceGuid.PcdEdkiiSystemFirmwareImageDescriptor|{0x0}|VOID*|0x100
  # {75BECB98-2B1A-475F-B7FE-C51F133FC69B}
  # 0x75becb98, 0x2b1a, 0x475f, 0xb7, 0xfe, 0xc5, 0x1f, 0x13, 0x3f, 0xc6, 0x9b
  gEfiMdeModulePkgTokenSpaceGuid.PcdSystemFmpCapsuleImageTypeIdGuid|{0x98, 0xcb, 0xbe, 0x75, 0x1a, 0x2b, 0x5f, 0x47, 0xb7, 0xfe, 0xc5, 0x1f, 0x13, 0x3f, 0xc6, 0x9b}
  # {8F355603-A26B-4327-BF83-E40032971969}
  # 0x8f355603, 0xa26b, 0x4327, 0xbf, 0x83, 0xe4, 0x0, 0x32, 0x97, 0x19, 0x69
  gEfiSignedCapsulePkgTokenSpaceGuid.PcdEdkiiSystemFirmwareFileGuid|{0x03, 0x56, 0x35, 0x8f, 0x6b, 0xa2, 0x27, 0x43, 0xbf, 0x83, 0xe4, 0x0, 0x32, 0x97, 0x19, 0x69}
!endif
