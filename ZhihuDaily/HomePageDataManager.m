//
//  HomePageDataManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HomePageDataManager.h"

@interface HomePageDataManager ()

@property (nonatomic, strong) NSMutableDictionary *homePageDic;

@end

@implementation HomePageDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(HomePageDataManager)

- (instancetype)init{
    if (self = [super init]) {
        _homePageDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    return self;
}

@end
