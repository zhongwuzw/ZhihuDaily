//
//  ThemsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemesListResponseModel.h"
#import "SingleThemeResponseModel.h"

@implementation ThemesListResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"others":@"others",
             @"subscribed":@"subscribed",
             @"limit":@"limit"
             };
}

+ (NSValueTransformer *)othersJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SingleThemeResponseModel class]];
}

+ (NSValueTransformer *)subscribedJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SingleThemeResponseModel class]];
}

@end
