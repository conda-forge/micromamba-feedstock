echo ON

cmake -S mamba ^
    -B build ^
    -D CMAKE_MSVC_RUNTIME_LIBRARY="MultiThreadedDLL" ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_BUILD_TYPE="Release" ^
    -D BUILD_LIBMAMBA=ON ^
    -D BUILD_LIBMAMBA_SPDLOG=ON ^
    -D BUILD_STATIC=ON ^
    -D BUILD_MICROMAMBA=ON ^
    -G "Ninja"
if %errorlevel% NEQ 0 exit /b %errorlevel%

cmake --build build --parallel %CPU_COUNT% --verbose
if %errorlevel% NEQ 0 exit /b %errorlevel%

cmake --install build
if %errorlevel% NEQ 0 exit /b %errorlevel%

DEL /Q /F /S "%LIBRARY_PREFIX%\lib\libmamba*"
if %errorlevel% NEQ 0 exit /b %errorlevel%
RMDIR /S /Q "%LIBRARY_PREFIX%\include\mamba"
if %errorlevel% NEQ 0 exit /b %errorlevel%
RMDIR /S /Q "%LIBRARY_PREFIX%\lib\cmake\libmamba"
if %errorlevel% NEQ 0 exit /b %errorlevel%
