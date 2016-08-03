//
//  HTTPManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HTTPManager.h"
#import <AFHTTPSessionManager.h>

#define MAX_CONCURRENT_HTTP_REQUEST_COUNT 3

#define INTERNAL_TIME_OUT   45

@interface HTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;

@end

@implementation HTTPManager

- (id)init{
    if (self = [super init]) {
        _afManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        [_afManager.operationQueue setMaxConcurrentOperationCount:MAX_CONCURRENT_HTTP_REQUEST_COUNT];
        _afManager.completionQueue = dispatch_queue_create("zhihu.completion.queue", DISPATCH_QUEUE_SERIAL);
        _afManager.requestSerializer.timeoutInterval = INTERNAL_TIME_OUT;
    }
    return self;
}

@end
