//
//  UINavigationBar+BackgroundColor.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)

@property (nonatomic, strong) UIView *overlay;

- (void)setBarBGColor:(UIColor *)backgroundColor;
- (void)removeBGColor;

@end
