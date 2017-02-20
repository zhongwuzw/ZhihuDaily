//
//  UserConfig.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/30.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "UserConfig.h"

#define BlockPicture @"isBlockPicture"

@implementation UserConfig
@synthesize isBlockPicture;

SYNTHESIZE_SINGLETON_FOR_CLASS(UserConfig)

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                     selector:@selector(savePref)
                         name:UIApplicationWillTerminateNotification
                       object:nil];
    }
    return self;
}

- (BOOL)isBlockPicture{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:BlockPicture];
}

- (void)setIsBlockPicture:(BOOL)blockPicture{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:blockPicture forKey:BlockPicture];
}

- (void)savePref{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
