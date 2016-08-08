//
//  WeakTarget.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/8.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "WeakTarget.h"

@interface WeakTarget ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation WeakTarget

- (instancetype)initWithTarget:(id)target selector:(SEL)sel{
    if (self = [super init]) {
        _target = target;
        _selector = sel;
    }
    
    return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
    if(_target)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_target performSelector:_selector withObject:timer];
        
#pragma clang diagnostic pop
    }
    else
    {
        [timer invalidate];
    }
}

@end
