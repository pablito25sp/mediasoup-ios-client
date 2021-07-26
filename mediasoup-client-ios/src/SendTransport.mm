//
//  SendTransport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "SendTransport.h"
#import "TransportWrapper.h"
#import "Producer.h"

@implementation SendTransport : Transport

NSString * const ERR_DOMAIN = @"mediasup-client-ios.SendTransport";

-(instancetype)initWithNativeTransport:(NSValue *)nativeTransport {
  self = [super initWithNativeTransport:nativeTransport];
  if (self) {
    self._nativeTransport = nativeTransport;
  }
  return self;
}

-(void)dispose {
  if ([self transportExists]) {
    [TransportWrapper nativeFreeTransport:self._nativeTransport];
  }
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions error:(NSError **)errPtr {
  return [self produce:listener track:track encodings:encodings codecOptions:codecOptions appData:nil error:errPtr];
}

-(Producer *)produce:(id<ProducerListener>)listener track:(RTCMediaStreamTrack *)track encodings:(NSArray *)encodings codecOptions:(NSString *)codecOptions appData:(NSString *)appData error:(NSError **)errPtr {
  if (![self transportExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDisposedError userInfo:nil];
    }
    return nil;
  }

  @try {
    return [TransportWrapper nativeProduce:self._nativeTransport listener:listener track:track.hash encodings:encodings codecOptions:codecOptions appData:appData];
  }
  @catch (NSException *exception) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:RuntimeError userInfo:nil];
    }
    return nil;
  }
}

-(bool)transportExists {
  return self._nativeTransport != nil;
}

@end
