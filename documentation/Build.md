# clean
```rm -rf build/*```
# arm64
```xcodebuild -project mediasoup-client-ios.xcodeproj -scheme mediasoup-client-ios -configuration Release -arch arm64 only_active_arch=no -sdk "iphoneos" -derivedDataPath build```
# x86_64
```xcodebuild -project mediasoup-client-ios.xcodeproj -scheme mediasoup-client-ios -configuration Release -arch x86_64 only_active_arch=no -sdk "iphonesimulator" -derivedDataPath build```
