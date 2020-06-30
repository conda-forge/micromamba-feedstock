mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
		 -DCMAKE_BUILD_TYPE="Release" ^
		 -DBUILD_EXE=ON ^
		 -DBUILD_BINDINGS=OFF

ninja install
