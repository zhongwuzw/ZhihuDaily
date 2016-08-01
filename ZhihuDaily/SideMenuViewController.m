//
//  SideMenuViewController.m
//
//
//  Created by 钟武 on 16/8/1.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@property (strong, readwrite, nonatomic) UIButton *contentButton;
@property (strong, readwrite, nonatomic) UIView *menuViewContainer;
@property (strong, readwrite, nonatomic) UIView *contentViewContainer;

@end

@implementation SideMenuViewController

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
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuViewContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuViewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:CGRectGetWidth(self.view.bounds)/2]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_menuViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuViewContainer)]];
    
    if (self.menuViewController) {
        [self addContainerConstraints:self.menuViewController container:self.menuViewContainer];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentViewContainer)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentViewContainer]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentViewContainer)]];
    
    if (self.contentViewController) {
        [self addContainerConstraints:self.contentViewController container:self.contentViewContainer];
    }
}

- (void)addGesture{
    self.view.multipleTouchEnabled = NO;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)addContainerConstraints:(UIViewController *)controller container:(UIView *)container{
    [self addChildViewController:controller];
    [container addSubview:controller.view];
    
    UIView *view = controller.view;
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    [controller didMoveToParentViewController:self];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer{
    
}

- (void)hideMenuViewController{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
