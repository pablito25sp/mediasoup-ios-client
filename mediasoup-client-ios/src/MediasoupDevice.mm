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

  [DeviceWrapper nativeLoad:self._nativeDevice routerRtpCapabilities:routerRtpCapabilities];
  return YES;
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

  return [DeviceWrapper nativeGetRtpCapabilities:self._nativeDevice];
}

-(NSString *)getSctpCapabilities:(NSError **)errPtr {
  if (![self deviceExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDeviceDisposedError userInfo:nil];
    }
    return nil;
  }

  return [DeviceWrapper nativeGetSctpCapabilities:self._nativeDevice];
}

-(bool)canProduce:(NSString *)kind {
  if (![self deviceExists]) {
    return false;
  }
  
  return [DeviceWrapper nativeCanProduce:self._nativeDevice kind:kind];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createSendTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil];
}

-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    [self checkDeviceExists];
    
    NSObject *transport = [DeviceWrapper nativeCreateSendTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    
    return [[SendTransport alloc] initWithNativeTransport:transport];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters {
    return [self createRecvTransport:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:nil options:nil appData:nil];
}

-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters options:(RTCPeerConnectionFactoryOptions *)options appData:(NSString *)appData {
    [self checkDeviceExists];
    
    NSObject *transport = [DeviceWrapper nativeCreateRecvTransport:self._nativeDevice listener:listener id:id iceParameters:iceParameters iceCandidates:iceCandidates dtlsParameters:dtlsParameters sctpParameters:sctpParameters options:options appData:appData];
    
    return [[RecvTransport alloc] initWithNativeTransport:transport];
}

-(void)checkDeviceExists {
    if (self._nativeDevice == nil) {
        NSException* exception = [NSException exceptionWithName:@"IllegalStateException" reason:@"Device has been disposed." userInfo:nil];
        
        throw exception;
    }
}

-(bool)deviceExists {
  return self._nativeDevice != nil;
}

@end
