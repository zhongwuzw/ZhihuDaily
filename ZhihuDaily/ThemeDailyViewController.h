//
//  ThemeDailyViewController.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class SideMenuViewController;

@interface ThemeDailyViewController : BaseViewController

@property (nonatomic, assign) NSInteger themeID;
@property (nonatomic, weak) SideMenuViewController *sideMenuViewController;

@end
