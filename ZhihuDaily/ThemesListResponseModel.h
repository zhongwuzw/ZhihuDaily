//
//  ThemsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SingleThemeResponseModel;

@interface ThemesListResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray<SingleThemeResponseModel *> *others;
@property (nonatomic, copy, readonly) NSArray<SingleThemeResponseModel *> *subscribed;
@property (nonatomic, assign, readonly) NSInteger limit;

@end
