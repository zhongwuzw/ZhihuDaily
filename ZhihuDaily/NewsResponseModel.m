//
//  NewsResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "NewsResponseModel.h"

@implementation NewsResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"images":@"images",
             @"type":@"type",
             @"storyID":@"id",
             @"title":@"title"
             };
}

@end
