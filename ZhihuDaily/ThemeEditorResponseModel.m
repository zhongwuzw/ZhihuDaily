//
//  ThemeEditorResponseModel.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeEditorResponseModel.h"

@implementation ThemeEditorResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"url":@"url",
             @"bio":@"bio",
             @"editorID":@"editorID",
             @"avatar":@"avatar",
             @"name":@"name"
             };
}

@end
