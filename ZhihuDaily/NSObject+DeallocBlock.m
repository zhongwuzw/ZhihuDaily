//
//  NSObject+DeallocBlock.m
//  WonderPlayerDemo
//
//  Created by Yanjun Zhuang on 14/6/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>
#import "DeallocBlockExecutor.h"

static void *kNSObject_DeallocBlocks;

@implementation NSObject (DeallocBlock)
- (id)addDeallocBlock:(void (^)())deallocBlock
{
    if (deallocBlock == nil) {
        return nil;
    }
    
    NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &kNSObject_DeallocBlocks);
    if (deallocBlocks == nil) {
        deallocBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &kNSObject_DeallocBlocks, deallocBlocks, OBJC_ASSOCIATION_RETAIN);
    }
    // Check if the block is already existed
    for (DeallocBlockExecutor *executor in deallocBlocks) {
        if (executor.deallocBlock == deallocBlock) {
            return nil;
        }
    }
    
    DeallocBlockExecutor *executor = [DeallocBlockExecutor executorWithDeallocBlock:deallocBlock];
    [deallocBlocks addObject:executor];
    return executor;
}

@end
