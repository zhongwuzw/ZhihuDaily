//
//  ThemeDetailResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NewsResponseModel;
@class ThemeEditorResponseModel;

@interface ThemeDetailResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray<NewsResponseModel *> *stories;
@property (nonatomic, copy, readonly) NSArray<ThemeEditorResponseModel *> *editors;
@property (nonatomic, copy, readonly) NSString *background;
@property (nonatomic, copy, readonly) NSString *name;

@end
