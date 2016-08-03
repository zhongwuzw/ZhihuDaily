//
//  LatestNewsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NewsResponseModel;
@class TopNewsResponseModel;

@interface LatestNewsResponseModel : MTLModel <MTLJSONSerializing>

@property (nonnull, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSArray<NewsResponseModel *> *stories;
@property (nonatomic, copy, readonly) NSArray<TopNewsResponseModel *> *topStories;

@end
