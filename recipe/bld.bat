mkdir build
if %errorlevel% NEQ 0 exit /b %errorlevel%
cd build

ROBOCOPY %RECIPE_DIR%\libsolv %VCPKG_ROOT%\ports\libsolv
@rem ROBOCOPY has 0 and 1 as successful exit codes
if %errorlevel% NEQ 0 if %errorlevel% NEQ 1 exit /b %errorlevel%

@rem Looks like the .vcpkg-root file is missing in vcpkg package
TYPE NUL > %VCPKG_ROOT%\.vcpkg-root

SET MSYS_FILE=%BUILD_PREFIX%\Library\share\vcpkg\scripts\cmake\vcpkg_acquire_msys.cmake
sed -i s/b309799e5a9d248ef66eaf11a0bd21bf4e8b9bd5c677c627ec83fa760ce9f0b54ddf1b62cbb436e641fbbde71e3b61cb71ff541d866f8ca7717a3a0dbeb00ebf/a202ddaefa93d8a4b15431dc514e3a6200c47275c5a0027c09cc32b28bc079b1b9a93d5ef65adafdc9aba5f76a42f3303b1492106ddf72e67f1801ebfe6d02cc/g %MSYS_FILE%
sed -i s/libtool-2.4.6-9/libtool-2.4.7-3/g %BUILD_PREFIX%\Library\share\vcpkg\scripts\cmake\vcpkg_acquire_msys.cmake %MSYS_FILE%
cat %MSYS_FILE%

SET VCPKG_BUILD_TYPE=release
vcpkg install libsolv[conda] --triplet x64-windows-static
if %errorlevel% NEQ 0 exit /b %errorlevel%
vcpkg install "libarchive[bzip2,lz4,lzma,lzo,openssl,zstd]" --triplet x64-windows-static
if %errorlevel% NEQ 0 exit /b %errorlevel%
vcpkg install curl --triplet x64-windows-static
if %errorlevel% NEQ 0 exit /b %errorlevel%
vcpkg install yaml-cpp --triplet x64-windows-static
if %errorlevel% NEQ 0 exit /b %errorlevel%
vcpkg install reproc --triplet x64-windows-static
if %errorlevel% NEQ 0 exit /b %errorlevel%

SET "CXXFLAGS=%CXXFLAGS% /showIncludes"
SET CMAKE_PREFIX_PATH=%VCPKG_ROOT%\installed\x64-windows-static\;%CMAKE_PREFIX_PATH%

cmake .. ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_PREFIX_PATH="%VCPKG_ROOT%\installed\x64-windows-static\;%CMAKE_PREFIX_PATH%" ^
    -D CMAKE_BUILD_TYPE="Release" ^
    -D BUILD_LIBMAMBA=ON ^
    -D BUILD_STATIC_DEPS=ON ^
    -D BUILD_MICROMAMBA=ON ^
    -D MICROMAMBA_LINKAGE=FULL_STATIC ^
    -G "Ninja"
if %errorlevel% NEQ 0 exit /b %errorlevel%

ninja install --verbose
if %errorlevel% NEQ 0 exit /b %errorlevel%

DEL /Q /F /S "%LIBRARY_PREFIX%\lib\libmamba*"
if %errorlevel% NEQ 0 exit /b %errorlevel%
RMDIR /S /Q "%LIBRARY_PREFIX%\include\mamba"
if %errorlevel% NEQ 0 exit /b %errorlevel%
RMDIR /S /Q "%LIBRARY_PREFIX%\lib\cmake\libmamba"
if %errorlevel% NEQ 0 exit /b %errorlevel%
