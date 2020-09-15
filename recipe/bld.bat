mkdir build
cd build

vcpkg install libarchive --triplet=x64-windows-static
vcpkg install curl --triplet=x64-windows-static
vcpkg install yaml-cpp --triplet=x64-windows-static

set CMAKE_PREFIX_PATH=%VCPKG_ROOT%\installed\x64-windows-static\;%CMAKE_PREFIX_PATH%

cmake .. ^
 	-D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-D CMAKE_BUILD_TYPE="Release" ^
	-D BUILD_EXE=ON ^
	-D BUILD_BINDINGS=OFF ^
	-G "Ninja"

ninja install
