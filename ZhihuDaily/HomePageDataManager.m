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
        
        if ([[_homePageArray firstObject].date isEqualToString:latestNewsModel.date]) {
            if ([_homePageArray firstObject].stories.count != latestNewsModel.stories.count) {
                [_homePageArray removeObjectAtIndex:0];
                [_homePageArray insertObject:latestNewsModel atIndex:0];
                self.topNewsArray = latestNewsModel.topStories;
                
                if (success) {
                    success(task,model);
                }
            }
            else{
                //小的trick，内容相同时不重新reload collectionview
                if (fail) {
                    fail(task,model);
                }
            }
        }
        else{
            [_homePageArray insertObject:latestNewsModel atIndex:0];
            self.currentDate = latestNewsModel.date;
            self.topNewsArray = latestNewsModel.topStories;
            
            if (success) {
                success(task,model);
            }
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

- (NSInteger)getNextNewsWithSection:(NSInteger *)section currentID:(NSInteger)currentID{
    NewsListResponseModel *model = _homePageArray[*section];
    
    __block NSInteger nextNews = -1;
    __block BOOL isFound = NO;
    
    [model.stories enumerateObjectsUsingBlock:^(NewsResponseModel *model, NSUInteger idx, BOOL *stop){
        if (isFound) {
            nextNews = model.storyID;
            *stop = YES;
        }
        if (model.storyID == currentID) {
            isFound = YES;
        }
    }];
    
    if (nextNews > 0) {
        return nextNews;
    }
    
    if (*section + 1 < _homePageArray.count) {
        nextNews = [_homePageArray[*section + 1].stories firstObject].storyID;
        *section += 1;
        return nextNews;
    }
    
    [self getPreviousNewsWithSuccess:nil fail:nil];
    
    return nextNews;
}

- (NSInteger)getPreviousNewsWithSection:(NSInteger *)section currentID:(NSInteger)currentID{
    NewsListResponseModel *model = _homePageArray[*section];
    
    __block NSInteger previousNews = -1;
    
    [model.stories enumerateObjectsUsingBlock:^(NewsResponseModel *model, NSUInteger idx, BOOL *stop){
        if (model.storyID == currentID) {
            *stop = YES;
        }
        else
            previousNews = model.storyID;
    }];
    
    if (previousNews > 0) {
        return previousNews;
    }
    
    if (*section - 1 >= 0) {
        previousNews = [_homePageArray[*section - 1].stories lastObject].storyID;
        *section -= 1;
        return previousNews;
    }
    
    return previousNews;
}

@end
