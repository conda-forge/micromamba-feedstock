mkdir build
cd build

rem where /R C:\ curl.h
rem where /R D:\ curl.h

ROBOCOPY %RECIPE_DIR%\libsolv %VCPKG_ROOT%\ports\libsolv
ROBOCOPY %RECIPE_DIR%\curl %VCPKG_ROOT%\ports\curl
ROBOCOPY %RECIPE_DIR%\reproc %VCPKG_ROOT%\ports\reproc

SET VCPKG_BUILD_TYPE=release
vcpkg install libsolv[conda] --triplet x64-windows-static
vcpkg install "libarchive[bzip2,lz4,lzma,lzo,openssl,zstd]" --triplet x64-windows-static
vcpkg install "curl" --triplet x64-windows-static
vcpkg install yaml-cpp --triplet x64-windows-static
vcpkg install reproc --triplet x64-windows-static

SET "CXXFLAGS=%CXXFLAGS% /showIncludes"
set CMAKE_PREFIX_PATH=%VCPKG_ROOT%\installed\x64-windows-static\;%CMAKE_PREFIX_PATH%

cmake .. ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_PREFIX_PATH="%VCPKG_ROOT%\installed\x64-windows-static\;%CMAKE_PREFIX_PATH%" ^
    -D CMAKE_BUILD_TYPE="Release" ^
    -D BUILD_EXE=ON ^
    -D BUILD_STATIC=ON ^
    -D BUILD_SHARED=OFF ^
    -D STATIC_DEPENDENCIES=ON ^
    -D BUILD_BINDINGS=OFF ^
    -D USE_VENDORED_CLI11=ON ^
    -G "Ninja"

ninja install --verbose
