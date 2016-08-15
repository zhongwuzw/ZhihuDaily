//
//  ThemeDailyDataManager.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeDailyDataManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ThemeDailyDataManager)
- (NSURLSessionDataTask *)getThemeWithThemeID:(NSInteger)themeID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail;

@end
