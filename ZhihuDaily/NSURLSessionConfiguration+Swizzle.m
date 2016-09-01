//
//  NSURLSessionConfiguration+Swizzle.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/9/1.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "NSURLSessionConfiguration+Swizzle.h"
#import "PictureBlockURLProtocol.h"

#import <objc/runtime.h>

@implementation NSURLSessionConfiguration (Swizzle)

+ (NSURLSessionConfiguration *)zw_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zw_defaultSessionConfiguration];
    NSArray *protocolClasses = @[[PictureBlockURLProtocol class]];
    configuration.protocolClasses = protocolClasses;
    
    return configuration;
}

+ (void)load{
    Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method zwMethod = class_getClassMethod([self class], @selector(zw_defaultSessionConfiguration));
    method_exchangeImplementations(systemMethod, zwMethod);
    
    [NSURLProtocol registerClass:[PictureBlockURLProtocol class]];
}

@end
