mkdir build
cd build

cmake ${CMAKE_ARGS} .. -DCMAKE_INSTALL_PREFIX=${PREFIX} \
		 -DCMAKE_BUILD_TYPE="Release" \
		 -DBUILD_EXE=ON \
		 -DBUILD_BINDINGS=OFF \
		 -DLINK_STATIC=ON

make -j${CPU_COUNT}
make install

strip ${PREFIX}/bin/micromamba