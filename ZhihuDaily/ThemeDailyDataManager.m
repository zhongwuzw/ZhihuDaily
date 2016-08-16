//
//  ThemeDailyDataManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyDataManager.h"
#import "ThemeDetailResponseModel.h"

@implementation ThemeDailyDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ThemeDailyDataManager)

- (NSURLSessionDataTask *)getThemeWithThemeID:(NSInteger)themeID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    return [[HTTPClient sharedInstance] getThemeWithThemeID:themeID success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        ThemeDetailResponseModel *detailModel = (ThemeDetailResponseModel *)model;
        self.themesArray = detailModel.stories;
        self.editorsArray = detailModel.editors;
        self.background = detailModel.background;
        self.name = detailModel.name;
        
        if (success) {
            success(task,model);
        }
    }fail:fail];
}

@end
