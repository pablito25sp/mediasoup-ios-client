//
//  Consumer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/RTCPeerConnectionFactory.h>
#import "Error.h"
#import "Consumer.h"
#import "ConsumerWrapper.h"

@implementation Consumer : NSObject

NSString * const ERR_DOMAIN = @"mediasup-client-ios.Consumer";

-(instancetype)initWithNativeConsumer:(NSValue *)nativeConsumer {
  self = [super init];
  if (self) {
    self._nativeConsumer = nativeConsumer;
    rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track([ConsumerWrapper getNativeTrack:self._nativeConsumer]);
    self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:[[RTCPeerConnectionFactory alloc] init]];
  }
  return self;
}

-(NSString *)getId {
  if ([self consumerExists]) {
    return [ConsumerWrapper getNativeId:self._nativeConsumer];
  } else {
    return nil;
  }
}

-(NSString *)getProducerId {
  if ([self consumerExists]) {
    return [ConsumerWrapper getNativeProducerId:self._nativeConsumer];
  } else {
    return nil;
  }
}

-(bool)isClosed {
  if ([self consumerExists]) {
    return [ConsumerWrapper isNativeClosed:self._nativeConsumer];
  } else {
    return true;
  }
}

-(bool)isPaused {
  if ([self consumerExists]) {
    return [ConsumerWrapper isNativePaused:self._nativeConsumer];
  } else {
    return true;
  }
}

-(NSString *)getKind {
  if ([self consumerExists]) {
    return [ConsumerWrapper getNativeKind:self._nativeConsumer];
  } else {
    return nil;
  }
}

-(RTCMediaStreamTrack *)getTrack {
  return self._nativeTrack;
}

-(NSString *)getRtpParameters {
  if ([self consumerExists]) {
    return [ConsumerWrapper getNativeRtpParameters:self._nativeConsumer];
  } else {
    return nil;
  }
}

-(NSString *)getAppData {
  if ([self consumerExists]) {
    return [ConsumerWrapper getNativeAppData:self._nativeConsumer];
  } else {
    return nil;
  }
}

-(void)resume {
  if ([self consumerExists]) {
    [ConsumerWrapper nativeResume:self._nativeConsumer];
  }
}

-(void)pause {
  if ([self consumerExists]) {
    [ConsumerWrapper nativePause:self._nativeConsumer];
  }
}

-(NSString *)getStats {
  if ([self consumerExists]) {
    @try {
      return [ConsumerWrapper getNativeStats:self._nativeConsumer];
    } @catch (NSException *exception) {
      return nil;
    }
  } else {
    return nil;
  }
}

-(void)close {
  if ([self consumerExists]) {
    [ConsumerWrapper nativeClose:self._nativeConsumer];
    [self._nativeConsumer release];
  }
  if (self._nativeTrack != nil) {
    [self._nativeTrack release];
  }
}

-(bool)consumerExists {
  return self._nativeConsumer != nil;
}

@end
