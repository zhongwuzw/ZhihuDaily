//
//  LatestNewsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "LatestNewsResponseModel.h"
#import "NewsResponseModel.h"
#import "TopNewsResponseModel.h"

@implementation LatestNewsResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"date":@"date",
             @"stories":@"stories",
             @"topStories":@"top_stories"
             };
}

+ (NSValueTransformer *)storiesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NewsResponseModel class]];
}

+ (NSValueTransformer *)topStoriesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TopNewsResponseModel class]];
}

@end
