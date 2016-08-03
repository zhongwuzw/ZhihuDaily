//
//  HTTPClient.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseResponseModel;

typedef void (^HttpClientSuccessBlock)(NSURLSessionDataTask *operation, BaseResponseModel *model);
typedef void (^HttpClientFailureBlock)(NSURLSessionDataTask *operation, BaseResponseModel *model);

@interface HTTPClient : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HTTPClient)

- (NSURLSessionDataTask *)getLatestNewsWithSuccess:(HttpClientSuccessBlock)success
                                         fail:(HttpClientFailureBlock)fail;

@end
