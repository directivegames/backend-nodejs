CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKSPACE=$CURR_DIR
HOMEPATH=~
VERSION=16.16.0

echo "=====[Patching Node.js]====="
cd $WORKSPACE/node
node $WORKSPACE/node-script/do-gitpatch.js -p $WORKSPACE/patchs/lib_uv_add_on_watcher_queue_updated_v$VERSION.patch
node $WORKSPACE/node-script/add_arraybuffer_new_without_stl.js deps/v8
node $WORKSPACE/node-script/make_v8_inspector_export.js

echo "=====[Building Node.js]====="

./configure --shared
make -j8

mkdir -p ../puerts-node/nodejs/include
mkdir -p ../puerts-node/nodejs/deps/uv/include
mkdir -p ../puerts-node/nodejs/deps/v8/include

cp src/node.h ../puerts-node/nodejs/include
cp src/node_version.h ../puerts-node/nodejs/include
cp -r deps/uv/include ../puerts-node/nodejs/deps/uv
cp -r deps/v8/include ../puerts-node/nodejs/deps/v8

mkdir -p ../puerts-node/nodejs/lib/Linux/
cp out/Release/libnode.so.* ../puerts-node/nodejs/lib/Linux/

git reset --hard
