//
//  TestViewController.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BaseResponseModel;
@class SideMenuViewController;

@interface HomePageViewController : BaseViewController

@property (nonatomic, strong) BaseResponseModel *newsModel;
@property (nonatomic, weak) SideMenuViewController *sideMenuController;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HomePageViewController)

@end
