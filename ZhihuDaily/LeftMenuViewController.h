//
//  LeftMenuViewController.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class HomePageViewController;
@class SideMenuViewController;

@interface LeftMenuViewController : BaseViewController

@property (nonatomic, weak) HomePageViewController *homePageViewController;
@property (nonatomic, weak) SideMenuViewController *sideMenuController;

@end
