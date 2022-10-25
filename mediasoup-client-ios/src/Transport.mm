//
//  Transport.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "Transport.h"
#import "TransportWrapper.h"

@implementation Transport : NSObject

-(instancetype)initWithNativeTransport:(NSValue *)nativeTransport {
  self = [super init];
  if (self) {
    self._nativeTransport = nativeTransport;
  }
  return self;
}

-(NSString *)getId {
  if ([self transportExists]) {
    return [TransportWrapper getNativeId:self._nativeTransport];
  } else {
    return nil;
  }
}

-(NSString *)getConnectionState {
  if ([self transportExists]) {
    return [TransportWrapper getNativeConnectionState:self._nativeTransport];
  } else {
    return nil;
  }
}

-(NSString *)getAppData {
  if ([self transportExists]) {
    return [TransportWrapper getNativeAppData:self._nativeTransport];
  } else {
    return nil;
  }
}

-(NSString *)getStats {
  if ([self transportExists]) {
    @try {
      return [TransportWrapper getNativeStats:self._nativeTransport];
    } @catch (NSException *exception) {
      return nil;
    }
  } else {
    return nil;
  }
}

-(bool)isClosed {
  if ([self transportExists]) {
    return [TransportWrapper isNativeClosed:self._nativeTransport];
  } else {
    return true;
  }
}

-(void)restartIce:(NSString *)iceParameters {
  if ([self transportExists]) {
    @try {
      [TransportWrapper nativeRestartIce:self._nativeTransport iceParameters:iceParameters];
    } @catch (NSException *exception) {
      // should change this method and return something?
    }
  }
}

-(void)updateIceServers:(NSString *)iceServers {
  if ([self transportExists]) {
    @try {
      [TransportWrapper nativeUpdateIceServers:self._nativeTransport iceServers:iceServers];
    } @catch (NSException *exception) {
      // should change this method and return something?
    }
  }
}

-(void)close {
  if ([self transportExists]) {
    [TransportWrapper nativeClose:self._nativeTransport];
    // [self._nativeTransport release];
  }
}

-(bool)transportExists {
  return self._nativeTransport != nil;
}

@end
