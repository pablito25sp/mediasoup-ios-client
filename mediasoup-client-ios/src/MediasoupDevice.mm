//
//  Device.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MediasoupDevice.h"
#import "DeviceWrapper.h"

@implementation MediasoupDevice : NSObject

NSString * const ERR_DOMAIN = @"mediasup-client-ios.MediasoupDevice";

-(instancetype)init {
  self = [super init];
  if (self) {
    self._nativeDevice = [DeviceWrapper nativeNewDevice];
  }
  return self;
}

-(BOOL)load:(NSString *)routerRtpCapabilities error:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return NO;
  }

  @try {
    [DeviceWrapper nativeLoad:self._nativeDevice routerRtpCapabilities:routerRtpCapabilities];
    return YES;
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:LoadError userInfo:nil];
    }
    return NO;
  }
}

-(bool)isLoaded {
  if (![self deviceExists]) {
    return false;
  }
  
  return [DeviceWrapper nativeIsLoaded:self._nativeDevice];
}

-(NSString *)getRtpCapabilities:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return nil;
  }

  if (![self isLoaded]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NotLoadedError userInfo:nil];
    }
    return nil;
  }

  @try {
    return [DeviceWrapper nativeGetRtpCapabilities:self._nativeDevice];
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:RuntimeError userInfo:nil];
    }
    return nil;
  }
}

-(NSString *)getSctpCapabilities:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return nil;
  }

  if (![self isLoaded]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NotLoadedError userInfo:nil];
    }
    return nil;
  }

  @try {
    return [DeviceWrapper nativeGetSctpCapabilities:self._nativeDevice];
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:RuntimeError userInfo:nil];
    }
    return nil;
  }
}

-(bool)canProduce:(NSString *)kind {
  if (![self deviceExists]) {
    return false;
  }
  
  @try {
    return [DeviceWrapper nativeCanProduce:self._nativeDevice kind:kind];
  }
  @catch (NSException *exception) {
    return false;
  }
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters error:(NSError **)errPtr {
  return [self createSendTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil error:errPtr];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData error:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return nil;
  }

  @try {
    NSObject *transport = [DeviceWrapper nativeCreateSendTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    return [[SendTransport alloc] initWithNativeTransport:transport];
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:RuntimeError userInfo:nil];
    }
    return nil;
  }
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters error:(NSError **)errPtr {
  return [self createRecvTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil error:errPtr];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData error:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return nil;
  }

  @try {
    NSObject *transport = [DeviceWrapper nativeCreateRecvTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    return [[RecvTransport alloc] initWithNativeTransport:transport];
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:RuntimeError userInfo:nil];
    }
    return nil;
  }
}

-(bool)deviceExists {
  return self._nativeDevice != nil;
}

@end
