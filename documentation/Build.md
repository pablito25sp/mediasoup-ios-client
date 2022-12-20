# webrtc build
```
export PATH=/Users/pablito25sp/workspace/depot_tools:$PATH
gclient sync
cd src
nano -w tools_webrtc/ios/build_ios_libs.py
python tools_webrtc/ios/build_ios_libs.py --extra-gn-args='is_component_build=false rtc_include_tests=false rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false'
cd out_ios_libs
ninja -C arm64_libs/ webrtc
ninja -C x64_libs/ webrtc

mkdir universal
lipo -create arm64_libs/obj/libwebrtc.a x64_libs/obj/libwebrtc.a -output universal/libwebrtc.a
```

# mediasoup-client-ios dependencies build
```
cd /Users/pablito25sp/workspace/mediasoup-ios-client/mediasoup-client-ios/dependencies/

cmake . -Bbuild \
  -DLIBWEBRTC_INCLUDE_PATH=/Users/pablito25sp/workspace/playground/livekit/webrtc-chrome-src/src \
  -DLIBWEBRTC_BINARY_PATH=/Users/pablito25sp/workspace/mediasoup-ios-client/mediasoup-client-ios/dependencies/webrtc/src/out_ios_libs/universal \
  -DMEDIASOUP_LOG_TRACE=ON -DMEDIASOUP_LOG_DEV=ON -DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
  -DLIBSDPTRANSFORM_BUILD_TESTS=OFF -DIOS_SDK=iphone -DIOS_ARCHS="arm64"

make -C build

cmake . -Bbuild_86_64 \
  -DLIBWEBRTC_INCLUDE_PATH=/Users/pablito25sp/workspace/playground/livekit/webrtc-chrome-src/src \
  -DLIBWEBRTC_BINARY_PATH=/Users/pablito25sp/workspace/mediasoup-ios-client/mediasoup-client-ios/dependencies/webrtc/src/out_ios_libs/universal \
  -DMEDIASOUP_LOG_TRACE=ON -DMEDIASOUP_LOG_DEV=ON -DCMAKE_CXX_FLAGS="-fvisibility=hidden" \
  -DLIBSDPTRANSFORM_BUILD_TESTS=OFF -DIOS_SDK=iphonesimulator -DIOS_ARCHS="x86_64"

make -C build_86_64

lipo -create build/libmediasoupclient/libmediasoupclient.a build_86_64/libmediasoupclient/libmediasoupclient.a -output libmediasoupclient/lib/libmediasoupclient.a

lipo -create build/libmediasoupclient/libsdptransform/libsdptransform.a build_86_64/libmediasoupclient/libsdptransform/libsdptransform.a -output libmediasoupclient/lib/libsdptransform.a
```
Once build include the libwebrtc.a, libmediasoup.a, libsdptransform.a in the project

# clean
```
rm -rf build/*
```
# arm64
```
xcodebuild -project mediasoup-client-ios.xcodeproj -scheme mediasoup-client-ios -configuration Release -arch arm64 only_active_arch=no -sdk "iphoneos" -derivedDataPath build
```
# x86_64
```
xcodebuild -project mediasoup-client-ios.xcodeproj -scheme mediasoup-client-ios -configuration Release -arch x86_64 only_active_arch=no -sdk "iphonesimulator" -derivedDataPath build
```
