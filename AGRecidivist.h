//
//  AGRecidivist.h
//  Pods
//
//  Created by Anton Gaenko on 04.02.14.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface AGRecidivist : NSObject

// you can set delay here before next attempt (0 for no delay)
typedef NSTimeInterval (^DelayForAttempt)(AFHTTPRequestOperation *prevOperation, NSError *error, int attempt);
// you can provide another request (URL, params and etc) for new attempt
typedef NSURLRequest* (^RequestForAttempt)(AFHTTPRequestOperation *prevOperation, NSError *error, int attempt);

// internal operation we should repeat
@property (strong) AFHTTPRequestOperation* operation;
// callback to set delay in seconds
@property (copy) DelayForAttempt delayProvider;
// callback to change request
@property (copy) RequestForAttempt urlProvider;

// counter to set max attempts
@property (readonly, assign) int attempts;
// current iteration
@property (readonly, assign) int curAttempt;

-(instancetype)initWithAttemptsToRetry:(int) attempts;
// increment attempts counter
-(void) attempt;

@end
