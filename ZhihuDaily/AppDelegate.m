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

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <objc/runtime.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (NSURLSessionConfiguration *)zw_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [AppDelegate zw_defaultSessionConfiguration];
    NSArray *protocolClasses = @[[PictureBlockURLProtocol class]];
    configuration.protocolClasses = protocolClasses;
    
    return configuration;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [self configureReachability];
    
    [self configurePictureURLProtocol];
    
    [self configureRootVC];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    
    return YES;
}

- (void)configurePictureURLProtocol{
    Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method zwMethod = class_getClassMethod([AppDelegate class], @selector(zw_defaultSessionConfiguration));
    method_exchangeImplementations(systemMethod, zwMethod);
    
    [NSURLProtocol registerClass:[PictureBlockURLProtocol class]];
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
