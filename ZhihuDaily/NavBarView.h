//
//  NavBarView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/5.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavBarView : UIView

@property (nonatomic,weak) NSLayoutConstraint *backgroundHeightConstraint;
@property (nonatomic, strong, readonly) UIButton *leftButton;

- (void)setBackgroundViewColor:(UIColor *)color;
- (void)setTitleLabelHidden:(BOOL)hidden;
- (void)updateProgress:(CGFloat)progress;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;
- (BOOL)isActivityIndicatorAnimating;

@end
