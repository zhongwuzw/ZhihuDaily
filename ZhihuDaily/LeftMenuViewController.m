//
//  LeftMenuViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "ThemesListResponseModel.h"
#import "SingleThemeResponseModel.h"
#import "HomePageViewController.h"
#import "ThemeDailyViewController.h"
#import "SideMenuViewController.h"
#import "ThemeManager.h"
#import "SkinStyle.h"
#import "SettingsViewController.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<SingleThemeResponseModel *> *dataArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) ThemeDailyViewController *themeDailyViewController;

@end

@implementation LeftMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArray = [NSMutableArray arrayWithCapacity:14];
        _selectedIndex = 0;
    }
    
    return self;
}

- (void)initUI{
    self.view.themeMap = @{kThemeMapKeyColorName : @"left_menu_bg"};
    [self.tableView registerClass:[LeftMenuTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)initData{
    SingleThemeResponseModel *homeModel = [[SingleThemeResponseModel alloc] initWithDictionary:@{@"name":@"首页",@"themeID":@(-1)} error:nil];
    [_dataArray addObject:homeModel];

    [[HTTPClient sharedInstance] getThemesListWithSuccess:^(NSURLSessionDataTask *task,BaseResponseModel *model){
        ThemesListResponseModel *themesModel = (ThemesListResponseModel *)model;
        [self.dataArray addObjectsFromArray:themesModel.others];
        [self.tableView reloadData];
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        
    }];
}

#pragma mark - Handle Button Cliked

- (IBAction)handleButtonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            
            break;
        case 2:
            [self handleNightModeButtonClicked:sender];
            break;
        case 3:
        {
            SettingsViewController *settingVC = [SettingsViewController new];
            settingVC.sideMenuController = self.sideMenuController;
            
            [self.homePageViewController.navigationController pushViewController:settingVC animated:NO];
            [self.sideMenuController hideMenuViewController];
            break;
        }
        default:
            break;
    }
}

- (void)handleNightModeButtonClicked:(UIButton *)button{
    NSInteger skinID = [ThemeManager sharedInstance].skinInstance.skinID;
    switch (skinID) {
        case 1:
            [button setImage:[UIImage imageNamed:@"Menu_Day"] forState:UIControlStateNormal];
            [button setTitle:@"白天" forState:UIControlStateNormal];
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"Menu_Dark"] forState:UIControlStateNormal];
            [button setTitle:@"夜间" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [[ThemeManager sharedInstance] switchToStyle];
}

#pragma mark - UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SingleThemeResponseModel *singleModel = self.dataArray[indexPath.row];
    cell.textLabel.text = singleModel.name;
    
    if (indexPath.row == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"Menu_Icon_Home"]];
    }
    else
        [cell.imageView setImage:nil];
    
    if (_selectedIndex == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    
    if (indexPath.row != 0) {

        if (self.themeDailyViewController) {
            self.themeDailyViewController.themeID = _dataArray[indexPath.row].themeID;
            self.themeDailyViewController.titleName = _dataArray[indexPath.row].name;
            self.themeDailyViewController.sideMenuViewController = self.sideMenuController;
            [self.themeDailyViewController reloadData];
        }
        else{
            self.themeDailyViewController = [ThemeDailyViewController new];
            self.themeDailyViewController.themeID = _dataArray[indexPath.row].themeID;
            self.themeDailyViewController.titleName = _dataArray[indexPath.row].name;
            self.themeDailyViewController.sideMenuViewController = self.sideMenuController;
        }
        [self.homePageViewController.navigationController setViewControllers:@[self.homePageViewController,self.themeDailyViewController] animated:NO];
    }
    else{
        [self.homePageViewController.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [self.sideMenuController hideMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
