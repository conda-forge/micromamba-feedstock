# Conda's binary relocation can result in string changing which can result in errors like
#    > warning: command substitution: ignored null byte in input
# https://github.com/mamba-org/mamba/issues/1517
export CXXFLAGS="${CXXFLAGS} -fno-merge-constants"
export CFLAGS="${CFLAGS} -fno-merge-constants"
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY=1"

cmake -B build \
    -G Ninja \
    ${CMAKE_ARGS} \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D CMAKE_BUILD_TYPE="Release" \
    -D BUILD_LIBMAMBA=ON \
    -D BUILD_STATIC_DEPS=ON \
    -D BUILD_MICROMAMBA=ON \
    -D MICROMAMBA_LINKAGE=FULL_STATIC
cmake --build build/ --parallel ${CPU_COUNT}
cmake --install build/

# remove everything related to `libmamba`
rm -rf $PREFIX/lib/libmamba*
rm -rf $PREFIX/include/mamba
rm -rf $PREFIX/lib/cmake/libmamba

${STRIP:-strip} ${PREFIX}/bin/micromamba

if [[ "$target_platform" == "osx-"* ]]; then
  ${OTOOL:-otool} -l ${PREFIX}/bin/micromamba
fi
