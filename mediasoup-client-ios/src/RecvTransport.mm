//
//  RecvTransport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "RecvTransport.h"
#import "TransportWrapper.h"
#import "Consumer.h"

@implementation RecvTransport : Transport

NSString * const ERR_DOMAIN = @"mediasup-client-ios.RecvTransport";

-(instancetype)initWithNativeTransport:(NSObject *)nativeTransport {
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

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters error:(NSError **)errPtr {
  return [self consume:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:nil error:errPtr];
}

-(Consumer *)consume:(id<ConsumerListener>)listener id:(NSString *)id producerId:(NSString *)producerId kind:(NSString *)kind rtpParameters:(NSString *)rtpParameters appData:(NSString *)appData error:(NSError **)errPtr {
  if (![self transportExists]) {
    if (errPtr) {
      *errPtr = [NSError errorWithDomain:ERR_DOMAIN code:NativeDisposedError userInfo:nil];
    }
    return nil;
  }

  @try {
    @synchronized(self) {
      return [TransportWrapper nativeConsume:self._nativeTransport listener:listener id:id producerId:producerId kind:kind rtpParameters:rtpParameters appData:appData];
    }
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
