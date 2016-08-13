//
//  PopAnimator.m
//  VCInteractiveTransition
//
//  Created by 钟武 on 16/6/12.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "PopAnimator.h"

@implementation PopAnimator

#pragma mark -
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    CGRect f = fromViewController.view.frame;
    f.origin.x = f.origin.x + f.size.width;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}

@end
