//
//  LatestNewsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NewsListResponseModel.h"

@class TopNewsResponseModel;

@interface LatestNewsResponseModel : NewsListResponseModel

@property (nonatomic, copy, readonly, nullable) NSArray<TopNewsResponseModel *> *topStories;

@end
