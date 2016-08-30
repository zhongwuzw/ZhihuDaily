//
//  SettingsViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/30.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingNavBarView.h"
#import "SettingsTableViewCell.h"
#import "SideMenuViewController.h"

#define CELL_IDENTIFIER @"cell"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SettingNavBarView *navBarView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initUI{
    self.tableView = [UITableView new];
    self.tableView.themeMap = @{kThemeMapKeyColorName : @"table_bg"};
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SettingsTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:_tableView];
    
    self.navBarView = [SettingNavBarView new];
    [self.view addSubview:_navBarView];
    _navBarView.themeMap = @{kThemeMapKeyColorName : @"table_header_bg"};
    
    [_navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [_navBarView.leftButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navBarView]-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView,_tableView)]];
}

- (void)initData{
    [_navBarView setTitle:@"设置"];
    
    [_tableView reloadData];
}

#pragma mark - Controller Transition

- (void)menuButtonClicked:(UIButton *)button{
    [self.sideMenuController showMenuViewController];
}

#pragma mark - UITableViewDataSource Method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    cell.textLabel.text = @"移动网络不下载图片";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

@end
