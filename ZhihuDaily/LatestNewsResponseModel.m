//
//  LatestNewsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "LatestNewsResponseModel.h"
#import "TopNewsResponseModel.h"

@implementation LatestNewsResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dic addEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"top_stories" forKey:@"topStories"];
    
    return dic;
}

+ (NSValueTransformer *)topStoriesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TopNewsResponseModel class]];
}

@end
