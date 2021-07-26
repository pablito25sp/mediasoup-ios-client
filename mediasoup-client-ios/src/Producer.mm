//
//  Producer.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "Producer.h"
#import "ProducerWrapper.h"

@implementation Producer : NSObject

NSString * const ERR_DOMAIN = @"mediasup-client-ios.Producer";

-(instancetype)initWithNativeProducer:(NSValue *)nativeProducer {
  self = [super init];
  if (self) {
    self._nativeProducer = nativeProducer;
    rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> track([ProducerWrapper getNativeTrack:self._nativeProducer]);
    self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:track factory:[[RTCPeerConnectionFactory alloc] init]];
  }
  return self;
}

-(NSString *)getId {
  if ([self producerExists]) {
    return [ProducerWrapper getNativeId:self._nativeProducer];
  } else {
    return nil;
  }
}

-(bool)isClosed {
  if ([self producerExists]) {
    return [ProducerWrapper isNativeClosed:self._nativeProducer];
  } else {
    return true;
  }
}

-(NSString *)getKind {
  if ([self producerExists]) {
    return [ProducerWrapper getNativeKind:self._nativeProducer];
  } else {
    return nil;
  }
}

-(RTCMediaStreamTrack *)getTrack {
  return self._nativeTrack;
}

-(bool)isPaused {
  if ([self producerExists]) {
    return [ProducerWrapper isNativePaused:self._nativeProducer];
  } else {
    return true;
  }
}

-(int)getMaxSpatialLayer {
  if ([self producerExists]) {
    return [ProducerWrapper getNativeMaxSpatialLayer:self._nativeProducer];
  } else {
    return 0;
  }
}

-(NSString *)getAppData {
  if ([self producerExists]) {
    return [ProducerWrapper getNativeAppData:self._nativeProducer];
  } else {
    return nil;
  }
}

-(NSString *)getRtpParameters {
  if ([self producerExists]) {
    return [ProducerWrapper getNativeRtpParameters:self._nativeProducer];
  } else {
    return nil;
  }
}

-(void)resume {
  if ([self producerExists]) {
    [ProducerWrapper nativeResume:self._nativeProducer];
  }
}

-(void)pause {
  if ([self producerExists]) {
    [ProducerWrapper nativePause:self._nativeProducer];
  }
}

-(void)setMaxSpatialLayers:(int)layer {
  if ([self producerExists]) {
    @try {
      [ProducerWrapper setNativeMaxSpatialLayer:self._nativeProducer layer:layer];
    } @catch (NSException *exception) {
      // should change this method and return something?
    }
  }
}

-(void)replaceTrack:(RTCMediaStreamTrack *)track {
  if ([self producerExists]) {
    @try {
      [ProducerWrapper nativeReplaceTrack:self._nativeProducer track:track.hash];
      rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> mediaTrack([ProducerWrapper getNativeTrack:self._nativeProducer]);
      self._nativeTrack = [RTCMediaStreamTrack mediaTrackForNativeTrack:mediaTrack factory:[[RTCPeerConnectionFactory alloc] init]];
    } @catch (NSException *exception) {
      // should change this method and return something?
    }
  }
}

-(NSString *)getStats {
  if ([self producerExists]) {
    @try {
      return [ProducerWrapper getNativeStats:self._nativeProducer];
    } @catch (NSException *exception) {
      return nil;
    }
  } else {
    return nil;
  }
}

-(void)close {
  if ([self producerExists]) {
    [ProducerWrapper nativeClose:self._nativeProducer];
    [self._nativeProducer release];
  }
  if (self._nativeTrack != nil) {
    [self._nativeTrack release];
  }
}

-(bool)producerExists {
  return self._nativeProducer != nil;
}

@end
