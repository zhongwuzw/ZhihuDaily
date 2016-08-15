//
//  SingleThemeResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "SingleThemeResponseModel.h"

@implementation SingleThemeResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name":@"name",
             @"themeID":@"id",
             };
}

@end
