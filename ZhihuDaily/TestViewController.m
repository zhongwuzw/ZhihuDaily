//
//  TestViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "TestViewController.h"
#import "CircularCollectionView.h"

@interface TestViewController ()
@property (nonatomic, strong)CircularCollectionView *collectionView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor grayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[CircularCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setupDataForCollectionView];
    [self.collectionView reloadData];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.view addConstraint:self.heightConstraint];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    // Do any additional setup after loading the view.
}

- (void)handleTouch:(UIButton *)sender{
//    [self.collectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    [self.heightConstraint setConstant:-100];
    [self.view updateConstraintsIfNeeded];
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.collectionView.contentInset = UIEdgeInsetsZero;
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
