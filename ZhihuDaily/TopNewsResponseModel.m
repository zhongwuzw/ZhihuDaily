//
//  TopNewsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "TopNewsResponseModel.h"

@implementation TopNewsResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"image":@"image",
             @"type":@"type",
             @"storyID":@"id",
             @"title":@"title"
             };
}

@end
