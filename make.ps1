$parent = (Get-Item $PSScriptRoot ).parent.FullName
cmake -S . -B build64 `
  -DQTDIR="$PSScriptRoot/obs-deps/windows-deps-qt6-2023-04-12-x64" `
  -DDepsPath="$PSScriptRoot/obs-deps/windows-deps-2023-04-12-x64" `
  -DLIBOBS_INCLUDE_DIR="$parent/obs-studio/libobs" `
  -DLIBOBS_LIB="$parent/obs-studio/build64/libobs/RelWithDebInfo/obs.lib" `
  -DOBS_FRONTEND_LIB="$parent/obs-studio/build64/UI/obs-frontend-api/RelWithDebInfo/obs-frontend-api.lib" `
  -DPTHREAD_LIB="$parent/obs-studio/build64/deps/w32-pthreads/RelWithDebInfo/w32-pthreads.lib"
