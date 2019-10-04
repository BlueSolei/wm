pushd %~dp0
cd build\bin
if "%1"=="tests" (wmTest.exe) else (wm.exe)
popd
