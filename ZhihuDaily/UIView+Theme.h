//
//  UIView+Theme.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NigntModeConstants.h"

extern NSString *kThemeMapKeyImageName;
extern NSString *kThemeMapKeyHighlightedImageName;
extern NSString *kThemeMapKeySelectedImageName;
extern NSString *kThemeMapKeyDisabledImageName;

extern NSString *kThemeMapKeyColorName;
extern NSString *kThemeMapKeyHighlightedColorName;
extern NSString *kThemeMapKeySelectedColorName;
extern NSString *kThemeMapKeyDisabledColorName;

extern NSString *kThemeMapKeyBgColorName;

@interface UIView (Theme)

@property (nonatomic, copy) NSDictionary *themeMap;

- (void)themeChanged;

@end
