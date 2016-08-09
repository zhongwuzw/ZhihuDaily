//
//  HomePageDataManager.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageDataManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HomePageDataManager)

- (NSURLSessionDataTask *)getLatestNewsWithSuccess:(HttpClientSuccessBlock)success
                                              fail:(HttpClientFailureBlock)fail;
@end
