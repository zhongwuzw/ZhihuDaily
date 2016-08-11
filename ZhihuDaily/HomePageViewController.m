//
//  TestViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeTopNewsCircularView.h"
#import "UINavigationBar+BackgroundColor.h"
#import "LatestNewsResponseModel.h"
#import "NewsResponseModel.h"
#import "TopNewsResponseModel.h"
#import "NewsTableViewCell.h"
#import "NavBarView.h"
#import "HomeNewsTableHeaderView.h"
#import "SideMenuViewController.h"
#import "HomePageDataManager.h"
#import "NewsDetailViewController.h"

#define NAVBAR_CHANGE_POINT 50
#define TABLE_HEADER_VIEW_HEIGHT 34
#define TABLE_VIEW_CELL_HEIGHT 82
#define PROGRESS_THRESHOLD 40

#define REUSE_TABLE_VIEW_CELL @"REUSE_TABLE_VIEW_CELL"
#define REUSE_TABLE_Header_VIEW_CELL @"REUSE_TABLE_Header_VIEW_CELL"

static const CGFloat TestViewControllerHeadScrollHeight = 176.0f;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HomeTopNewsCircularView *circularView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) NSMutableArray<NSArray *> *newsArray;
@property (nonatomic, copy, readonly) NSArray<TopNewsResponseModel *> *topNewsArray;
@property (nonatomic, strong, readonly) HomePageDataManager *homePageDataManager;
@property (nonatomic, strong) NavBarView *navBarView;

@end

@implementation HomePageViewController

#pragma mark - Getter Method
- (NSMutableArray *)newsArray{
    return self.homePageDataManager.homePageArray;
}

- (NSArray *)topNewsArray{
    return self.homePageDataManager.topNewsArray;
}

- (HomePageDataManager *)homePageDataManager{
    return [HomePageDataManager sharedInstance];
}

#pragma mark - Controller Event

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self initTableView];
    [self initCircularView];
    [self loadData];
    
    self.navBarView = [NavBarView new];
    [_navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_navBarView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [_navBarView.leftButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarTapNotification:) name:STATUS_BAR_TAP_NOTIFICATION object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STATUS_BAR_TAP_NOTIFICATION object:nil];
}

#pragma Observer Method

- (void)handleStatusBarTapNotification:(NSNotification *)notification{
    if (self.navigationController.visibleViewController == self) {
        [_tableView setContentOffset:CGPointZero animated:YES];
    }
}

#pragma Controller Transition

- (void)menuButtonClicked:(UIButton *)button{
    [self.sideMenuController showMenuViewController];
}

#pragma mark - Controller UI Init

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:_tableView];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), TestViewControllerHeadScrollHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:REUSE_TABLE_VIEW_CELL];
    [self.tableView registerClass:[HomeNewsTableHeaderView class] forHeaderFooterViewReuseIdentifier:REUSE_TABLE_Header_VIEW_CELL];
    
    self.tableView.rowHeight = TABLE_VIEW_CELL_HEIGHT;
}

- (void)initCircularView{
    
    self.circularView = [[HomeTopNewsCircularView alloc] initWithFrame:CGRectMake(0, -16, CGRectGetWidth(self.view.bounds), TestViewControllerHeadScrollHeight + 16)];
    
    [self.tableView addSubview:self.circularView];
    [self.tableView setClipsToBounds:NO];
}

#pragma mark - loadData Method

- (void)loadData{
    WEAK_REF(self)
    
    [self.homePageDataManager getLatestNewsWithSuccess:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_)
        if (self__) {
            [self__.circularView setupDataForCollectionViewWithArray:self__.topNewsArray];
            
            self__.circularView.TapActionBlock = ^(MTLModel <MTLJSONSerializing> * indexModel){
                NSLog(@"click model is %@",indexModel);
            };
            [self__.tableView reloadData];
            [_navBarView stopActivityIndicator];
        }
    }fail:^(NSURLSessionDataTask *task,BaseResponseModel *model){
        [_navBarView stopActivityIndicator];
    }];
}

#pragma mark - UITableViewDelegate Method

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }

    HomeNewsTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:REUSE_TABLE_Header_VIEW_CELL];
    
    [view setHeaderTitle:[self.homePageDataManager headerTitleForSection:section]];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return TABLE_HEADER_VIEW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsResponseModel *model = [self.homePageDataManager modelForRowAtIndexPath:indexPath];
    
    NewsDetailViewController *detailVC = [NewsDetailViewController new];
    detailVC.storyID = model.storyID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        [_navBarView.backgroundHeightConstraint setConstant:20];
        [_navBarView setTitleLabelHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        [_navBarView.backgroundHeightConstraint setConstant:50];
        [_navBarView setTitleLabelHidden:NO];
    }
}

#pragma mark - UITableViewDataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.newsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.homePageDataManager numberofRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_TABLE_VIEW_CELL];
    
    NewsResponseModel *model = [self.homePageDataManager modelForRowAtIndexPath:indexPath];
    
    [cell setTitleLabel:model.title imageURL:[model.images firstObject]];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Method

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat yoffset = scrollView.contentOffset.y;
    
    if (yoffset < 0 && -yoffset >= PROGRESS_THRESHOLD) {
        if (![_navBarView isActivityIndicatorAnimating]) {
            [_navBarView startActivityIndicator];
            [self loadData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        
        CGFloat progress = -yOffset / PROGRESS_THRESHOLD;
        [_navBarView updateProgress:progress];
        
        CGRect f = self.circularView.frame;
        f.origin.y = -16 + yOffset;
        f.size.height = TestViewControllerHeadScrollHeight + 16 - yOffset;
        self.circularView.frame = f;
    }
    else{
        if (yOffset > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - yOffset) / 64));
            [_navBarView setBackgroundViewColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:alpha]];
        } else {
            [_navBarView setBackgroundViewColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:0]];
        }
        
        if (yOffset + _tableView.height + TABLE_VIEW_CELL_HEIGHT > _tableView.contentSize.height) {
            [self.homePageDataManager getPreviousNewsWithSuccess:^(NSURLSessionDataTask *task, BaseResponseModel *model){
                NSInteger section = [self.homePageDataManager numberofSections];
                [_tableView insertSections:[NSIndexSet indexSetWithIndex:section - 1] withRowAnimation:UITableViewRowAnimationFade];
            }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
                ;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
