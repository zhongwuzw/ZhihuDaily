//
//  ThemeDailyDataManager.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsResponseModel;
@class ThemeEditorResponseModel;

@interface ThemeDailyDataManager : NSObject

@property (nonatomic, copy) NSArray<NewsResponseModel *> *themesArray;
@property (nonatomic, copy) NSArray<ThemeEditorResponseModel *> *editorsArray;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *name;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ThemeDailyDataManager)
- (NSURLSessionDataTask *)getThemeWithThemeID:(NSInteger)themeID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail;
- (NSInteger)numberofRows;
- (NSInteger)getPreviousNewsWithCurrentID:(NSInteger)currentID;
- (NSInteger)getNextNewsWithCurrentID:(NSInteger)currentID;
- (NewsResponseModel *)modelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
