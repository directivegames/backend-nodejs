set VERSION=16.16.0
set WORKSPACE=%~dp0%

pushd %~dp0%node

git reset --hard

echo =====[ Patching Node.js ]=====
node %WORKSPACE%\node-script\do-gitpatch.js -p %WORKSPACE%\patchs\win_build_v%VERSION%.patch
node %WORKSPACE%\node-script\do-gitpatch.js -p %WORKSPACE%\patchs\lib_uv_add_on_watcher_queue_updated_v%VERSION%.patch
copy /y %WORKSPACE%\node-script\zlib.def deps\zlib\win32\zlib.def
node %~dp0\node-script\add_arraybuffer_new_without_stl.js deps/v8
node %~dp0\node-script\make_v8_inspector_export.js

echo =====[ Building Node.js ]=====
.\vcbuild.bat dll openssl-no-asm

popd
