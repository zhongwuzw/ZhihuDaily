//
//  ThemeDailyDataManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyDataManager.h"

@implementation ThemeDailyDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ThemeDailyDataManager)

- (NSURLSessionDataTask *)getThemeWithThemeID:(NSInteger)themeID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    return [[HTTPClient sharedInstance] getThemeWithThemeID:themeID success:success fail:fail];
}

@end
