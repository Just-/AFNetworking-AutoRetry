//
// Created by Shai Ohev Zion on 1/21/14.

#import "AFHTTPRequestOperationManager+AutoRetry.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@implementation AFHTTPRequestOperationManager (AutoRetry)

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                                autoRetryOf:(int)timesToRetry {
    
    void (^retryBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        int retryCount = timesToRetry;
        if (retryCount > 0) {
            NSLog(@"AutoRetry: Request failed: %@, retry begining...", error.localizedDescription);
            AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:retryCount-1];
            [self.operationQueue addOperation:retryOperation];
        } else {
            NSLog(@"AutoRetry: Request failed: %@, no more retries allowed! executing supplied failure block...", error.localizedDescription);
            failure(operation, error);
            NSLog(@"AutoRetry: done.");
        }
    };

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NSLog(@"AutoRetry: success, running success block...");
        success(operation, responseObj);
        NSLog(@"AutoRetry: done.");
    } failure:retryBlock];

    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *requestOperation, __unused id responseObject) {
        if (success) {
            success(requestOperation);
        }
    } failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                         autoRetry:(int)timesToRetry
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry];
    [self.operationQueue addOperation:operation];

    return operation;
}

#pragma mark Recidivist methods

- (AGRecidivist *)POSTtoRepeat:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                     autoRetry:(int)timesToRetry
{
  NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
  AGRecidivist* r = [self HTTPRequestOperationWithRequestWithRecidivist:request success:success failure:failure autoRetryOf:timesToRetry];
  [self.operationQueue addOperation:r.operation];
  
  return r;
}


- (AGRecidivist *)GETtoRepeat:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    autoRetry:(int)timesToRetry
{
  NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
  AGRecidivist* r = [self HTTPRequestOperationWithRequestWithRecidivist:request success:success failure:failure autoRetryOf:timesToRetry];
  [self.operationQueue addOperation:r.operation];
  
  return r;
}

- (AGRecidivist *)HTTPRequestOperationWithRequestWithRecidivist:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                                autoRetryOf:(int)timesToRetry {
  AGRecidivist* r = [[AGRecidivist alloc] initWithAttemptsToRetry:timesToRetry];
  
  __block void (^retryBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    [r attempt];
    
    NSURLRequest* newReq = r.urlProvider ? r.urlProvider(operation, error, r.curAttempt) : operation.request;
    // if we should interrupt a sequence
    if (newReq && r.curAttempt <= r.attempts) {
      NSLog(@"AutoRetry: Request failed: %@, retry begining...", error.localizedDescription);
      
      NSTimeInterval delay = r.delayProvider ? r.delayProvider(operation, error, r.curAttempt) : 0.0;
      
      AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:newReq success:success failure:retryBlock];
      
      if (delay > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self.operationQueue addOperation:retryOperation];
        });
      } else {
        [self.operationQueue addOperation:retryOperation];
      }
    } else {
      // break coupling
      r.operation = nil;
      NSLog(@"AutoRetry: Request failed: %@, no more retries allowed! executing supplied failure block...", error.localizedDescription);
      failure(operation, error);
      NSLog(@"AutoRetry: done.");
    }
  };
  
  AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObj) {
    NSLog(@"AutoRetry: success, running success block...");
    // break coupling
    r.operation = nil;
    success(operation, responseObj);
    NSLog(@"AutoRetry: done.");
  } failure:retryBlock];
  
  r.operation = operation;
  
  return r;
}

@end

#pragma clang diagnostic pop