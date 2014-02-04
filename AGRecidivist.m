//
//  AGRecidivist.m
//  Pods
//
//  Created by Anton Gaenko on 04.02.14.
//
//

#import "AGRecidivist.h"

@implementation AGRecidivist

-(instancetype)initWithAttemptsToRetry:(int) attempts {
  self = [super init];
  if (self) {
    _attempts = attempts;
    _curAttempt = 1;
  }
  return self;
}

-(void) attempt {
  ++_curAttempt;
}

@end
