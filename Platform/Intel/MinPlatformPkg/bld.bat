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

call build -p MinPlatformPkg\MinCorePkg.dsc -a IA32 -a X64 -t VS2015x86 -y Report.txt

set CORE_FV_DIR=%WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin
set FV_BUILD_DIR=%WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV

if not exist %CORE_FV_DIR%\Core\DEBUG (
  mkdir %CORE_FV_DIR%\Core\DEBUG
)

copy %FV_BUILD_DIR%\FVPREMEMORYCORE.Fv %CORE_FV_DIR%\Core\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVPREMEMORYCORE.inf %CORE_FV_DIR%\Core\DEBUG\FVPREMEMORYCORE.inf /Y

copy %FV_BUILD_DIR%\FVUEFIBOOTCORE.Fv %CORE_FV_DIR%\Core\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFIBOOTCORE.inf %CORE_FV_DIR%\Core\DEBUG\FVUEFIBOOTCORE.inf /Y

copy %FV_BUILD_DIR%\FVOSBOOTCORE.Fv %CORE_FV_DIR%\Core\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVOSBOOTCORE.inf %CORE_FV_DIR%\Core\DEBUG\FVOSBOOTCORE.inf /Y

if not exist %CORE_FV_DIR%\UefiSecureBoot\DEBUG (
  mkdir %CORE_FV_DIR%\UefiSecureBoot\DEBUG
)

copy %FV_BUILD_DIR%\FVUEFISECUREBOOT.Fv %CORE_FV_DIR%\UefiSecureBoot\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFISECUREBOOT.inf %CORE_FV_DIR%\UefiSecureBoot\DEBUG\FVUEFISECUREBOOT.inf /Y

if not exist %CORE_FV_DIR%\Tcg\DEBUG (
  mkdir %CORE_FV_DIR%\Tcg\DEBUG
)

copy %FV_BUILD_DIR%\FVTCG.Fv %CORE_FV_DIR%\Tcg\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVTCG.inf %CORE_FV_DIR%\Tcg\DEBUG\FVTCG.inf /Y

if not exist %CORE_FV_DIR%\Network\DEBUG (
  mkdir %CORE_FV_DIR%\Network\DEBUG
)

copy %FV_BUILD_DIR%\FVUEFINETWORK.Fv %CORE_FV_DIR%\Network\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVUEFINETWORK.inf %CORE_FV_DIR%\Network\DEBUG\FVUEFINETWORK.inf /Y

if not exist %CORE_FV_DIR%\Crypt\DEBUG (
  mkdir %CORE_FV_DIR%\Crypt\DEBUG
)

copy %FV_BUILD_DIR%\FVCRYPT.Fv %CORE_FV_DIR%\Crypt\DEBUG\ /Y
copy %FV_BUILD_DIR%\AsBuildFVCRYPT.inf %CORE_FV_DIR%\Crypt\DEBUG\FVCRYPT.inf /Y

goto :EOF
