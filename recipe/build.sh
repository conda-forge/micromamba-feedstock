mkdir build
cd build

# Conda's binary relocation can result in string changing which can result in errors like
#    > warning: command substitution: ignored null byte in input
# https://github.com/mamba-org/mamba/issues/1517
if [[ "$target_platform" == "linux-"* ]]; then
  export CXXFLAGS="${CXXFLAGS} -fno-merge-constants"
  export CFLAGS="${CFLAGS} -fno-merge-constants"
fi

if [[ "$target_platform" == "osx-"* ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY=1"
  export LDFLAGS="${LDFLAGS} -Wl,-unexported_symbol,'*'"
fi

cmake ${CMAKE_ARGS} .. \
         -GNinja \
         -DCMAKE_INSTALL_PREFIX=${PREFIX} \
         -DCMAKE_BUILD_TYPE="Release" \
         -DBUILD_LIBMAMBA=ON \
         -DBUILD_STATIC_DEPS=ON \
         -DBUILD_MICROMAMBA=ON \
         -DMICROMAMBA_LINKAGE=FULL_STATIC

ninja

ninja install

# remove everything related to `libmamba`
rm -rf $PREFIX/lib/libmamba*
rm -rf $PREFIX/include/mamba
rm -rf $PREFIX/lib/cmake/libmamba

${STRIP:-strip} ${PREFIX}/bin/micromamba

if [[ "$target_platform" == "osx-"* ]]; then
  ${OTOOL:-otool} -l ${PREFIX}/bin/micromamba
fi
