//
//  NewsListResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "NewsListResponseModel.h"
#import "NewsResponseModel.h"

@implementation NewsListResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"date":@"date",
             @"stories":@"stories"
             };
}

+ (NSValueTransformer *)storiesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NewsResponseModel class]];
}

@end
