//
//  DetailNewsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/11.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "DetailNewsResponseModel.h"

@implementation DetailNewsResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"body":@"body",
             @"image_source":@"image_source",
             @"title":@"title",
             @"image":@"image",
             @"share_url":@"share_url",
             @"js":@"js",
             @"images":@"images",
             @"type":@"type",
             @"storyID":@"id",
             @"css":@"css"
             };
}

@end
