//
//  ThemeDetailResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDetailResponseModel.h"
#import "NewsResponseModel.h"
#import "ThemeEditorResponseModel.h"

@implementation ThemeDetailResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"stories":@"stories",
             @"editors":@"editors",
             @"background":@"background",
             @"name":@"name"
             };
}

+ (NSValueTransformer *)storiesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NewsResponseModel class]];
}

+ (NSValueTransformer *)editorsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ThemeEditorResponseModel class]];
}

@end
