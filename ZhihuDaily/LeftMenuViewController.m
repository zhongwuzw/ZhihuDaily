//
//  LeftMenuViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/9.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "ThemesResponseModel.h"
#import "SingleThemeResponseModel.h"
#import "HomePageViewController.h"
#import "ThemeDailyViewController.h"
#import "SideMenuViewController.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<SingleThemeResponseModel *> *dataArray;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation LeftMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArray = [NSMutableArray arrayWithCapacity:14];
        _selectedIndex = 0;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUI{
    [self.tableView registerClass:[LeftMenuTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)initData{
    SingleThemeResponseModel *homeModel = [[SingleThemeResponseModel alloc] initWithDictionary:@{@"name":@"首页",@"themeID":@(-1)} error:nil];
    [_dataArray addObject:homeModel];

    [[HTTPClient sharedInstance] getThemesListWithSuccess:^(NSURLSessionDataTask *task,BaseResponseModel *model){
        ThemesResponseModel *themesModel = (ThemesResponseModel *)model;
        [self.dataArray addObjectsFromArray:themesModel.others];
        [self.tableView reloadData];
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        
    }];
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
    if (_selectedIndex == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    
    ThemeDailyViewController *controller = nil;
    if (indexPath.row != 0) {
        controller = [ThemeDailyViewController new];
        controller.themeID = _dataArray[indexPath.row].themeID;
        
        [self.homePageViewController.navigationController setViewControllers:@[self.homePageViewController,controller] animated:NO];
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
