//
//  PushAnimator.m
//  VCInteractiveTransition
//
//  Created by 钟武 on 16/6/12.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "PushAnimator.h"

@interface PushAnimator ()

@property(nonatomic, strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation PushAnimator

#pragma mark -
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect f = fromViewController.view.frame;
    CGRect originRect = f;
    f.origin.x = f.origin.x + f.size.width;
    toViewController.view.frame = f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        toViewController.view.frame = originRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
