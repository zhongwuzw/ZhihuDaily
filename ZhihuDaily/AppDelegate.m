//
//  AppDelegate.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/1.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "AppDelegate.h"
#import "ZhiHuSideMenuViewController.h"
#import "HomePageViewController.h"
#import "LeftMenuViewController.h"
#import "LaunchViewController.h"
#import "ThemeManager.h"
#import "PictureBlockURLProtocol.h"
#import "UserConfig.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <objc/runtime.h>
#import <SDWebImageManager.h>

@interface AppDelegate ()<SDWebImageManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDLogDebug(@"Home Path : %@", HomePath);
    
    [SDWebImageManager sharedManager].delegate = self;
    
    [self configureReachability];
    
    [self configureRootVC];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    
    return YES;
}

- (void)configureReachability{
    self.reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
}

- (void)configureRootVC{
    LeftMenuViewController *leftVC = [LeftMenuViewController new];
    HomePageViewController *rightVC = [HomePageViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rightVC];
    
    ZhiHuSideMenuViewController *sideMenu = [[ZhiHuSideMenuViewController alloc] initWithContentViewController:navigationController menuViewController:leftVC];
    rightVC.sideMenuController = sideMenu;
    leftVC.sideMenuController = sideMenu;
    
    leftVC.homePageViewController = rightVC;
    
    [[ThemeManager sharedInstance] switchToStyleByID:THEME_STYLE_CLASSIC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = sideMenu;
    [self.window makeKeyAndVisible];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    NSSet<UITouch *> *events = [event allTouches];
    UITouch *touch = [events anyObject];
    CGPoint location = [touch locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STATUS_BAR_TAP_NOTIFICATION object:nil];
    }
}

//针对使用SDWebCache库下载图片时的情况做优化，直接在创建请求前期即进行拦截；其他情况如UIWebView的图片还是使用NSURLProtocol类
- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL{
    if ([[UserConfig sharedInstance] isBlockPicture] && [self isBlockPictureDownload]) {
        return NO;
    }
    return YES;
}

- (BOOL)isBlockPictureDownload{
    Reachability *reachability = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).reachability;
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    BOOL isBlock = netStatus == ReachableViaWWAN?YES : NO;
    
    return isBlock;
}

@end
