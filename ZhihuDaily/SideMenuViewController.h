//
//  SideMenuViewController.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/1.
//  Copyright © 2016年 钟武. All rights reserved.
//

@interface SideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;

- (id)initWithContentViewController:(UIViewController *)contentViewController
             menuViewController:(UIViewController *)menuViewController;
- (void)presentLeftMenuViewController;
- (void)hideMenuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
