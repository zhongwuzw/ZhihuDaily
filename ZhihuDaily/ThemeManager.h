//
//  ThemeManager.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkinStyle;

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *allStyleArray;
@property (nonatomic, copy) NSDictionary *themeConfig;
@property (nonatomic, copy) NSDictionary *colorConfig;
@property (nonatomic, strong) SkinStyle *skinInstance;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ThemeManager)
- (void)switchToStyleByID:(NSInteger)skinID;
- (void)switchToStyle;
- (NSDictionary *)getSkinInfo:(NSInteger)skinID;

@end
