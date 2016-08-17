//
//  ZhiHuSideMenuViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/17.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ZhiHuSideMenuViewController.h"
#import "LaunchViewController.h"

@interface ZhiHuSideMenuViewController ()

@property (nonatomic, strong) LaunchViewController *launchController;

@end

@implementation ZhiHuSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLaunchVC];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeLaunchViewController];
    });
}

- (void)initLaunchVC{
    self.launchController = [LaunchViewController new];
    [self addChildViewController:_launchController];
    [self.view addSubview:_launchController.view];
    [_launchController didMoveToParentViewController:self];
}

- (void)removeLaunchViewController{
    [_launchController willMoveToParentViewController:nil];
    [UIView animateWithDuration:.5 animations:^{
        _launchController.view.alpha = 0;
    }completion:^(BOOL finished){
        [_launchController.view removeFromSuperview];
        [_launchController removeFromParentViewController];
    }];
}

@end
