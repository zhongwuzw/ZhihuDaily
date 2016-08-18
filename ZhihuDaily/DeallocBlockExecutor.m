//
//  DeallocBlockExecutor.m
//  WonderPlayerDemo
//
//  Created by Yanjun Zhuang on 14/6/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "DeallocBlockExecutor.h"

@implementation DeallocBlockExecutor
+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock
{
    DeallocBlockExecutor *o = [DeallocBlockExecutor new];
    o.deallocBlock = deallocBlock;
    return o;
}

- (void)dealloc
{
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}
@end
