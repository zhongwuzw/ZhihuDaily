//
//  HomePageDataManager.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsResponseModel;
@class NewsListResponseModel;
@class TopNewsResponseModel;

@interface HomePageDataManager : NSObject

@property (nonatomic, strong) NSMutableArray<NewsListResponseModel *> *homePageArray;
@property (nonatomic, copy) NSArray<TopNewsResponseModel *> *topNewsArray;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HomePageDataManager)
- (NSURLSessionDataTask *)getLatestNewsWithSuccess:(HttpClientSuccessBlock)success
                                              fail:(HttpClientFailureBlock)fail;
- (NSURLSessionDataTask *)getPreviousNewsWithSuccess:(HttpClientSuccessBlock)success
                                              fail:(HttpClientFailureBlock)fail;
- (NSInteger)numberofSections;
- (NSInteger)numberofRowsInSection:(NSInteger)section;
- (NewsResponseModel *)modelForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)headerTitleForSection:(NSInteger)section;
- (NSInteger)getPreviousNewsWithSection:(NSInteger)section currentID:(NSInteger)currentID;
- (NSInteger)getNextNewsWithSection:(NSInteger *)section currentID:(NSInteger)currentID;

@end
