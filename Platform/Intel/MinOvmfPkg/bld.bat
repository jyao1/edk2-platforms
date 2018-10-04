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

call build -p MinOvmfPkg\MinOvmfPkg.dsc -a IA32 -a X64 -t %TOOL_CHAIN_TAG% -b %TARGET% -D DEBUG_ON_SERIAL_PORT -y Report.txt

set FV_PATH=%WORKSPACE%\Build\MinOvmf\%TARGET%_%TOOL_CHAIN_TAG%\FV
split -f %FV_PATH%\OVMF.fd -s 0x84000 -o %FV_PATH%\OVMF_VARS.fd -t %FV_PATH%\OVMF_CODE.fd
echo split is done.
