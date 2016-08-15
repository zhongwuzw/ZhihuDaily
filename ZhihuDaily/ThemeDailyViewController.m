//
//  ThemeDailyViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyViewController.h"
#import "ThemeNavBarView.h"
#import "SideMenuViewController.h"

@interface ThemeDailyViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) ThemeNavBarView *navBarView;
@end

@implementation ThemeDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initUI{
    self.navBarView = [ThemeNavBarView new];
    [_navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_navBarView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [_navBarView.leftButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [UITableView new];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navBarView]-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView,_tableView)]];
}

- (void)initData{
    
}

#pragma mark - Controller Transition

- (void)menuButtonClicked:(UIButton *)button{
    [self.sideMenuViewController showMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
