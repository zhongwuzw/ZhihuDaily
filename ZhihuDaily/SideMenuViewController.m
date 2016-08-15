//
//  SideMenuViewController.m
//
//
//  Created by 钟武 on 16/8/1.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@property (strong, nonatomic) UIButton *contentButton;
@property (strong, nonatomic) UIView *menuViewContainer;
@property (strong, nonatomic) UIView *contentViewContainer;

@end

@implementation SideMenuViewController

#pragma mark - Init方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    
    return self;
}
- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController{
    if (self = [self initWithNibName:nil bundle:nil]) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    
    return self;
}

- (void)commonInit{
    _menuViewContainer = [[UIView alloc] init];
    _contentViewContainer = [[UIView alloc] init];
    
    _animationDuration = 0.35f;
    
    _panMinimumOpenThreshold = 60.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self addGesture];
}

- (void)initUI{
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    [self.menuViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuViewContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:CGRectGetWidth(self.view.bounds)/2]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_menuViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuViewContainer)]];
    
    if (self.menuViewController) {
        [self addContainerConstraints:self.menuViewController container:self.menuViewContainer];
    }
    
    [self.contentViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentViewContainer)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentViewContainer)]];
    
    if (self.contentViewController) {
        [self addContainerConstraints:self.contentViewController container:self.contentViewContainer];
    }
}

#pragma mark - ContentVC Set方法

- (void)setContentViewController:(UIViewController *)contentViewController{
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    
    [self hideViewController:_contentViewController];
    _contentViewController = contentViewController;
    
    [self addContainerConstraints:_contentViewController container:self.contentViewContainer];
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated{
    if (_contentViewController == contentViewController) {
        return;
    }
    
    if (!animated) {
        [self setContentViewController:contentViewController];
    }
    else{
        [self addChildViewController:contentViewController];
        
        UIView *view = contentViewController.view;
        view.alpha = 0;
        [self.contentViewContainer addSubview:view];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.contentViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
        [UIView animateWithDuration:self.animationDuration animations:^{
            view.alpha = 1;
        }completion:^(BOOL finished){
            [self hideViewController:self.contentViewController];
            [contentViewController didMoveToParentViewController:self];
            _contentViewController = contentViewController;
            
            [self statusBarNeedsAppearanceUpdate];
        }];
    }
}

#pragma mark - Helper方法

- (void)addContainerConstraints:(UIViewController *)controller container:(UIView *)container{
    [self addChildViewController:controller];
    [container addSubview:controller.view];
    
    UIView *view = controller.view;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    [controller didMoveToParentViewController:self];
}

- (void)showMenuViewController{
    if (!self.menuViewController) {
        return;
    }
    [self.menuViewController beginAppearanceTransition:YES animated:YES];
    [self.view.window endEditing:YES];
    [self addContentButton];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewContainer.transform = CGAffineTransformMakeTranslation(CGRectGetMidX(self.view.bounds), 0);
        self.menuViewContainer.transform = self.contentViewContainer.transform;
    }completion:^(BOOL finished){
        [self.menuViewController endAppearanceTransition];
    }];
    
    [self statusBarNeedsAppearanceUpdate];
}

- (void)statusBarNeedsAppearanceUpdate
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [UIView animateWithDuration:0.3f animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    
    [self.contentViewContainer addSubview:self.contentButton];
    
    [self.contentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentButton)]];
    [self.contentViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentButton)]];
}

#pragma mark - Pan Gesture方法

- (void)addGesture{
    self.view.multipleTouchEnabled = NO;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self addContentButton];
        [self.view.window endEditing:YES];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.contentViewContainer.frame.origin.x == CGRectGetWidth(self.view.bounds)/2 && point.x > 0) {
            return;
        }
        
        if ((self.contentViewContainer.frame.origin.x <= 0 && point.x < 0) || self.contentViewContainer.frame.origin.x + point.x < 0) {
            self.contentViewContainer.transform = CGAffineTransformIdentity;
            self.menuViewContainer.transform = CGAffineTransformIdentity;
            return;
        }
        
        if (self.contentViewContainer.frame.origin.x + point.x > CGRectGetWidth(self.view.bounds)/2) {
            point.x = CGRectGetWidth(self.view.bounds)/2 - self.contentViewContainer.frame.origin.x;
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
        
        self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
        self.menuViewContainer.transform = self.contentViewContainer.transform;
        
        [self statusBarNeedsAppearanceUpdate];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.panMinimumOpenThreshold > 0 && (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < self.panMinimumOpenThreshold)){
            [self hideMenuViewController];
        }
        else if (self.contentViewContainer.frame.origin.x == 0) {
            [self hideMenuViewControllerAnimated:NO];
        }
        else{
            if ([recognizer velocityInView:self.view].x > 0) {
                [self showMenuViewController];
            }
            else
                [self hideMenuViewController];
        }
    }
}

#pragma mark - Hide方法

- (void)hideMenuViewController{
    [self hideMenuViewControllerAnimated:YES];
}

- (void)hideMenuViewControllerAnimated:(BOOL)animated{
    [self.menuViewController beginAppearanceTransition:NO animated:animated];
    
    [self.contentButton removeFromSuperview];
    
    WEAK_REF(self)
    
    void (^animationBlock)(void) = ^{
        STRONG_REF(self_)
        if (!self__) {
            return ;
        }
        self__.contentViewContainer.transform = CGAffineTransformIdentity;
        self__.menuViewContainer.transform = CGAffineTransformIdentity;
    };
    
    void (^completionBlock)(void) = ^{
        STRONG_REF(self_)
        if (!self__) {
            return ;
        }
        [self__.menuViewController endAppearanceTransition];
    };
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:self.animationDuration animations:^{
            animationBlock();
        }completion:^(BOOL finished){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
    
    [self statusBarNeedsAppearanceUpdate];
}

- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
