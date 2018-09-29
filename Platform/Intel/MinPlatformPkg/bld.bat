@REM @file
@REM
@REM Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
@REM This program and the accompanying materials
@REM are licensed and made available under the terms and conditions of the BSD License
@REM which accompanies this distribution.  The full text of the license may be found at
@REM http://opensource.org/licenses/bsd-license.php
@REM
@REM THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
@REM

@echo on
pushd ..\..\..\..\

@REM Set WORKSPACE environment.
set WORKSPACE=%cd%
echo.
echo Set WORKSPACE as: %WORKSPACE%
echo.

@REM Create the Conf directory under WORKSPACE
if not exist %WORKSPACE%\Conf (
  mkdir Conf
)

@REM Set other environments.
@REM Basic Rule:
@REM   Platform override Silicon override Core
@REM   Source override Binary

set PACKAGES_PATH=%WORKSPACE%\edk2-platforms\Platform\Intel;%WORKSPACE%\edk2-platforms\Silicon\Intel;%WORKSPACE%\edk2-non-osi\Silicon\Intel;%WORKSPACE%\FSP;%WORKSPACE%\edk2;%WORKSPACE%

@if not defined PYTHON_HOME (
  @if exist C:\Python27 (
    set PYTHON_HOME=C:\Python27
  )
)

pushd %WORKSPACE%\edk2
call edksetup.bat Rebuild
popd
pushd %WORKSPACE%
popd

set openssl_path=%WORKSPACE%

popd

set TOOL_CHAIN_TAG=VS2015x86

set TARGET=DEBUG
call :Copy_BIN_FV

set TARGET=RELEASE
call :Copy_BIN_FV

:done
GOTO :EOF

:Copy_BIN_FV

call build -p MinPlatformPkg\MinCorePkg.dsc -a IA32 -a X64 -t %TOOL_CHAIN_TAG% -b %TARGET% -y Report.txt

set CORE_FV_DIR=%WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin
set FV_BUILD_DIR=%WORKSPACE%\Build\MinCorePkg\%TARGET%_%TOOL_CHAIN_TAG%\FV

if not exist %CORE_FV_DIR%\Core\%TARGET% (
  mkdir %CORE_FV_DIR%\Core\%TARGET%
)

copy %FV_BUILD_DIR%\FVPREMEMORYCORE.Fv %CORE_FV_DIR%\Core\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVPREMEMORYCORE.inf %CORE_FV_DIR%\Core\%TARGET%\FVPREMEMORYCORE.inf /Y

copy %FV_BUILD_DIR%\FVUEFIBOOTCORE.Fv %CORE_FV_DIR%\Core\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFIBOOTCORE.inf %CORE_FV_DIR%\Core\%TARGET%\FVUEFIBOOTCORE.inf /Y

copy %FV_BUILD_DIR%\FVOSBOOTCORE.Fv %CORE_FV_DIR%\Core\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVOSBOOTCORE.inf %CORE_FV_DIR%\Core\%TARGET%\FVOSBOOTCORE.inf /Y

if not exist %CORE_FV_DIR%\UefiSecureBoot\%TARGET% (
  mkdir %CORE_FV_DIR%\UefiSecureBoot\%TARGET%
)

copy %FV_BUILD_DIR%\FVUEFISECUREBOOT.Fv %CORE_FV_DIR%\UefiSecureBoot\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFISECUREBOOT.inf %CORE_FV_DIR%\UefiSecureBoot\%TARGET%\FVUEFISECUREBOOT.inf /Y

if not exist %CORE_FV_DIR%\Tcg\%TARGET% (
  mkdir %CORE_FV_DIR%\Tcg\%TARGET%
)

copy %FV_BUILD_DIR%\FVTCG.Fv %CORE_FV_DIR%\Tcg\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVTCG.inf %CORE_FV_DIR%\Tcg\%TARGET%\FVTCG.inf /Y

if not exist %CORE_FV_DIR%\Network\%TARGET% (
  mkdir %CORE_FV_DIR%\Network\%TARGET%
)

copy %FV_BUILD_DIR%\FVUEFINETWORK.Fv %CORE_FV_DIR%\Network\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFINETWORK.inf %CORE_FV_DIR%\Network\%TARGET%\FVUEFINETWORK.inf /Y

if not exist %CORE_FV_DIR%\Crypt\%TARGET% (
  mkdir %CORE_FV_DIR%\Crypt\%TARGET%
)

copy %FV_BUILD_DIR%\FVCRYPT.Fv %CORE_FV_DIR%\Crypt\%TARGET%\ /Y
copy %FV_BUILD_DIR%\AsBuildFVCRYPT.inf %CORE_FV_DIR%\Crypt\%TARGET%\FVCRYPT.inf /Y

goto :EOF
