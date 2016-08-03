//
//  UINavigationBar+BackgroundColor.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

static void *kOverlay;

@implementation UINavigationBar (BackgroundColor)

- (UIView *)overlay{
    return objc_getAssociatedObject(self, &kOverlay);
}

- (void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &kOverlay, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBarBGColor:(UIColor *)backgroundColor{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

@end
