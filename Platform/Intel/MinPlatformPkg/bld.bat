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

if not exist %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG (
  mkdir %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG
)

copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\FVPREMEMORYCORE.Fv %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\ /Y
copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\AsBuildFVPREMEMORYCORE.inf %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\FVPREMEMORYCORE.inf /Y

copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\FVPOSTMEMORYCORE.Fv %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\ /Y


copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\FVUEFIBOOTCORE.Fv %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\ /Y
copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\AsBuildFVUEFIBOOTCOREUNCOMPACT.inf %WORKSPACE%\edk2\CoreFvBin\Core\DEBUG\FVUEFIBOOTCORE.inf /Y

copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\FVOSBOOTCORE.Fv %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\ /Y
copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\AsBuildFVOSBOOTCOREUNCOMPACT.inf %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Core\DEBUG\FVOSBOOTCORE.inf /Y

if not exist %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Network\DEBUG (
  mkdir %WORKSPACE%\edk2-platforms\Platform\Intel\CoreFvBin\Network\DEBUG
)

copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\FVUEFINETWORK.Fv %WORKSPACE%\edk2\CoreFvBin\Network\DEBUG\ /Y
copy %WORKSPACE%\Build\MinCorePkg\DEBUG_VS2015x86\FV\AsBuildFVUEFINETWORKUNCOMPACT.inf %WORKSPACE%\edk2\CoreFvBin\Network\DEBUG\FVUEFINETWORK.inf /Y

goto :EOF
