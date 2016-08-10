//
//  HomePageDataManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HomePageDataManager.h"
#import "LatestNewsResponseModel.h"
#import "NewsResponseModel.h"
#import "NewsListResponseModel.h"

@interface HomePageDataManager ()

@property (nonatomic, strong) NSMutableDictionary *newsIndexDic;
@property (nonatomic, assign) BOOL isPreviousLoading;
@property (nonatomic, copy) NSString *currentDate;

@end

@implementation HomePageDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(HomePageDataManager)

- (instancetype)init{
    if (self = [super init]) {
        _homePageArray = [NSMutableArray arrayWithCapacity:3];
        _newsIndexDic = [NSMutableDictionary dictionaryWithCapacity:3];
        _isPreviousLoading = NO;
    }
    
    return self;
}

- (NSURLSessionDataTask *)getLatestNewsWithSuccess:(HttpClientSuccessBlock)success
                                              fail:(HttpClientFailureBlock)fail{
    return [[HTTPClient sharedInstance] getLatestNewsWithSuccess:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        LatestNewsResponseModel *latestNewsModel = (LatestNewsResponseModel *)model;
        if (latestNewsModel.date && ![_newsIndexDic objectForKey:latestNewsModel.date]) {
            [_newsIndexDic setValue:[NSNumber numberWithInteger:0] forKey:latestNewsModel.date];
            [_homePageArray insertObject:latestNewsModel atIndex:0];
        }
        
        self.currentDate = latestNewsModel.date;
        
        self.topNewsArray = latestNewsModel.topStories;
        
        if (success) {
            success(task,model);
        }
        //            NSRange range;
        //            NSArray *newArray;
        //            if (self__.circularView.dataArray.count > 0) {
        //                range.location = 1;
        //                range.length = self__.circularView.dataArray.count - 2;
        //                newArray = [self__.circularView.dataArray subarrayWithRange:range];
        //            }
        //
        //            BOOL isEqual = [tempArray isEqualToArray:newArray];
    }fail:fail];
}

- (NSURLSessionDataTask *)getPreviousNewsWithSuccess:(HttpClientSuccessBlock)success
                                             fail:(HttpClientFailureBlock)fail{
    if (_isPreviousLoading) {
        return nil;
    }
    self.isPreviousLoading = YES;
    
    return [[HTTPClient sharedInstance] getPreviousNewsWithDate:self.currentDate success:^(NSURLSessionDataTask *task,BaseResponseModel *model){
        NewsListResponseModel *newsListModel = (NewsListResponseModel *)model;
        self.currentDate = newsListModel.date;
        [_homePageArray addObject:newsListModel];
        
        if (success) {
            success(task,model);
        }
        self.isPreviousLoading = NO;
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        self.isPreviousLoading = NO;
        if (fail) {
            fail(task,model);
        }
    }];
}

- (NSInteger)numberofSections{
    return self.homePageArray.count;
}
- (NSInteger)numberofRowsInSection:(NSInteger)section{
    return self.homePageArray[section].stories.count;
}
- (NewsResponseModel *)modelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.homePageArray[indexPath.section].stories[indexPath.row];
}

- (NSString *)headerTitleForSection:(NSInteger)section{
    return self.homePageArray[section].date;
}

@end
