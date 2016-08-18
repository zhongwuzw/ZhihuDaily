//
//  UIView+Theme.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "UIView+Theme.h"
#import "ThemeManager.h"
#import "NSObject+DeallocBlock.h"
#import "SkinStyle.h"

#import <objc/runtime.h>

NSString *kThemeMapKeyImageName             = @"kThemeMapKeyImageName";
NSString *kThemeMapKeyHighlightedImageName  = @"kThemeMapKeyHighlightedImageName";
NSString *kThemeMapKeySelectedImageName     = @"kThemeMapKeySelectedImageName";
NSString *kThemeMapKeyDisabledImageName     = @"kThemeMapKeyDisabledImageName";

NSString *kThemeMapKeyColorName             = @"kThemeMapKeyColorName";
NSString *kThemeMapKeyHighlightedColorName  = @"kThemeMapKeyHighlightedColorName";
NSString *kThemeMapKeySelectedColorName     = @"kThemeMapKeySelectedColorName";
NSString *kThemeMapKeyDisabledColorName     = @"kThemeMapKeyDisabledColorName";

NSString *kThemeMapKeyBgColorName           = @"kThemeMapKeyBgColorName";

static void *kUIView_ThemeMap;
static void *kUIView_DeallocHelper;

@implementation UIView (Theme)

- (void)setThemeMap:(NSDictionary *)themeMap
{
    objc_setAssociatedObject(self, &kUIView_ThemeMap, themeMap, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (themeMap) {
        @autoreleasepool {
            if (objc_getAssociatedObject(self, &kUIView_DeallocHelper) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // 注意：没有使用weak的原因是在dealloc方法中，weak会被置为nil，导致访问不到对象，所以使用__unsafe_unretained属性
                id deallocHelper = [self addDeallocBlock:^{
                    NSLog(@"deallocing %@", weakSelf);
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &kUIView_DeallocHelper, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
            [self themeChanged];
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    }
    
}

- (NSDictionary *)themeMap
{
    return objc_getAssociatedObject(self, &kUIView_ThemeMap);
}

- (void)themeChanged
{
    if (self.hidden) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [self changeTheme];
            }];
//            [self changeTheme];
        });
    }
    else {
        dispatch_main_sync_safe(^{
            [UIView animateWithDuration:0.5 animations:^{
                [self changeTheme];
            }];
//            [self changeTheme];
        })
    }
}

- (void)changeTheme
{
    NSDictionary *map = self.themeMap;
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *obj = (UILabel *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = TColor(map[kThemeMapKeyColorName]);
        }
        if (map[kThemeMapKeyHighlightedColorName]) {
            obj.highlightedTextColor = TColor(map[kThemeMapKeyHighlightedColorName]);
        }
        if (map[kThemeMapKeyBgColorName]) {
            obj.backgroundColor = TColor(map[kThemeMapKeyBgColorName]);
        }
    }
    else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *obj = (UIButton *)self;
        if (map[kThemeMapKeyColorName]) {
            [obj setTitleColor:TColor(map[kThemeMapKeyColorName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedColorName]) {
            [obj setTitleColor:TColor(map[kThemeMapKeyHighlightedColorName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeySelectedColorName]) {
            [obj setTitleColor:TColor(map[kThemeMapKeySelectedColorName]) forState:UIControlStateSelected];
        }
        if (map[kThemeMapKeyDisabledColorName]) {
            [obj setTitleColor:TColor(map[kThemeMapKeyDisabledColorName]) forState:UIControlStateDisabled];
        }
        if (map[kThemeMapKeyImageName]) {
            [obj setImage:TImage(map[kThemeMapKeyImageName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedImageName]) {
            [obj setImage:TImage(map[kThemeMapKeyHighlightedImageName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeySelectedImageName]) {
            [obj setImage:TImage(map[kThemeMapKeySelectedImageName]) forState:UIControlStateSelected];
        }
        if (map[kThemeMapKeyDisabledImageName]) {
            [obj setImage:TImage(map[kThemeMapKeyDisabledImageName]) forState:UIControlStateDisabled];
        }
        if (map[kThemeMapKeyBgColorName]) {
            obj.backgroundColor = TColor(map[kThemeMapKeyBgColorName]);
        }
    }
    else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *obj = (UIImageView *)self;
        if (map[kThemeMapKeyImageName]) {
            obj.image = TImage(map[kThemeMapKeyImageName]);
        }
        if (map[kThemeMapKeyHighlightedImageName]) {
            obj.highlightedImage = TImage(map[kThemeMapKeyHighlightedImageName]);
        }
        if (map[kThemeMapKeyColorName]) {
            obj.backgroundColor = TColor(map[kThemeMapKeyColorName]);
        }
    }
    else if ([self isKindOfClass:[UITextField class]]) {
        UITextField *obj = (UITextField *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = TColor(map[kThemeMapKeyColorName]);
        }
    }
    else if ([self isKindOfClass:[UITextView class]]) {
        UITextView *obj = (UITextView *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = TColor(map[kThemeMapKeyColorName]);
        }
    }
    else {
        if (map[kThemeMapKeyColorName]) {
            self.backgroundColor = TColor(map[kThemeMapKeyColorName]);
        }
    }
}

@end
