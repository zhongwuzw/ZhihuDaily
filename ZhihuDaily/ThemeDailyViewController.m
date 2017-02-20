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
#import "ThemeDailyDataManager.h"
#import "NewsResponseModel.h"
#import "ThemeEditorResponseModel.h"
#import "BaseResponseModel.h"
#import "ThemeDailyTableViewCell.h"
#import "ThemeEditorTableHeaderView.h"
#import "ThemeDetailViewController.h"
#import "Reachability.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define CELL_IDENTIFIER @"cell"
#define TABLE_VIEW_CELL_HEIGHT 82

@interface ThemeDailyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) ThemeNavBarView *navBarView;
@property (nonatomic, weak, readonly) ThemeDailyDataManager *themeDataManager;
@property (nonatomic, weak, readonly) NSArray<NewsResponseModel *> *themesArray;
@property (nonatomic, weak, readonly) NSArray<ThemeEditorResponseModel *> *editorsArray;
@property (nonatomic, weak, readonly) NSString *background;
@property (nonatomic, weak, readonly) NSString *name;
@property (nonatomic, strong) UIImageView *topBackImageView;

@end

@implementation ThemeDailyViewController

#pragma mark - Getter Method

- (ThemeDailyDataManager *)themeDataManager{
    return [ThemeDailyDataManager sharedInstance];
}

- (NSArray<NewsResponseModel *> *)themesArray{
    return self.themeDataManager.themesArray;
}

- (NSArray<ThemeEditorResponseModel *> *)editorsArray{
    return self.themeDataManager.editorsArray;
}

- (NSString *)background{
    return self.themeDataManager.background;
}

- (NSString *)name{
    return self.themeDataManager.name;
}

#pragma mark - VC Events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarTapNotification:) name:STATUS_BAR_TAP_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STATUS_BAR_TAP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Observer Method

- (void)reachabilityChanged:(NSNotification *)notification{
    Reachability *reachability = [notification object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    if (netStatus == ReachableViaWiFi) {
        dispatch_main_async_safe(^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - VC Init Method

- (void)initUI{
    self.tableView = [UITableView new];
    self.tableView.themeMap = @{kThemeMapKeyColorName : @"table_bg"};
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = TABLE_VIEW_CELL_HEIGHT;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ThemeDailyTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:_tableView];
    
    self.topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [self.topBackImageView setImage:[UIImage imageNamed:@"Home_Image_Mask"]];
    [self.topBackImageView setClipsToBounds:YES];
    self.topBackImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_topBackImageView];
    
    UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [self.view addSubview:topBackgroundView];
    
    self.navBarView = [ThemeNavBarView new];
    [self.view addSubview:_navBarView];
    
    [_navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [_navBarView.leftButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navBarView]-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView,_tableView)]];
}

- (void)initData{
    [_navBarView setTitle:_titleName];
    
    WEAK_REF(self);
    [self.themeDataManager getThemeWithThemeID:_themeID success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_);
        if (self__) {
            ThemeEditorTableHeaderView *headerView = [[ThemeEditorTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self__.view.width, 40)];
            [headerView installEditorListWithArray:self__.editorsArray];
            [self__.topBackImageView sd_setImageWithURL:[NSURL URLWithString:self__.background] placeholderImage:self__.topBackImageView.image];
            self__.tableView.tableHeaderView = headerView;
            [self__.tableView reloadData];
        }
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        
    }];
}

- (void)reloadData{
    [self initData];
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsResponseModel *model = [self.themeDataManager modelForRowAtIndexPath:indexPath];
    
    [self transitionToDetailNewsVC:model.storyID];
}

#pragma mark - UITableViewDataSource Method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    NewsResponseModel *model = [self.themesArray objectAtIndex:indexPath.row];
    [cell setTitleLabel:model.title imageURL:model.images.firstObject];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.themesArray.count;
}

#pragma mark - UIScrollViewDelegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGRect f = _topBackImageView.frame;
        f.origin.y = 0;
        f.size.height = 50 - yOffset;
        _topBackImageView.frame = f;
    }
}

#pragma mark - Controller Transition

- (void)menuButtonClicked:(UIButton *)button{
    [self.sideMenuViewController showMenuViewController];
}
     
- (void)transitionToDetailNewsVC:(NSInteger)storyID{
    ThemeDetailViewController *detailVC = [ThemeDetailViewController new];
    detailVC.storyID = storyID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma Observer Method

- (void)handleStatusBarTapNotification:(NSNotification *)notification{
    [_tableView setContentOffset:CGPointZero animated:YES];
}

- (void)dealloc{
    DDLogDebug(@"ThemeDailyViewController dealloc");
}

@end
