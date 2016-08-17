//
//  ThemeDailyDataManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyDataManager.h"
#import "ThemeDetailResponseModel.h"
#import "NewsResponseModel.h"

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

- (NSInteger)numberofRows{
    return self.themesArray.count;
}

- (NSInteger)getPreviousNewsWithCurrentID:(NSInteger)currentID{
    __block NSInteger previousNews = -1;
    
    [self.themesArray enumerateObjectsUsingBlock:^(NewsResponseModel *model, NSUInteger idx, BOOL *stop){
        if (model.storyID == currentID) {
            *stop = YES;
        }
        else
            previousNews = model.storyID;
    }];
    
    return previousNews;
}

- (NSInteger)getNextNewsWithCurrentID:(NSInteger)currentID{
    __block NSInteger nextNews = -1;
    __block BOOL isFound = NO;
    
    [self.themesArray enumerateObjectsUsingBlock:^(NewsResponseModel *model, NSUInteger idx, BOOL *stop){
        if (isFound) {
            nextNews = model.storyID;
            *stop = YES;
        }
        if (model.storyID == currentID) {
            isFound = YES;
        }
    }];
    
    return nextNews;
}

- (NewsResponseModel *)modelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.themesArray[indexPath.row];
}

@end
