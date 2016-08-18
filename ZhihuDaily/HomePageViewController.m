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
#import "PushAnimator.h"
#import "PopAnimator.h"
#import "ThemeDailyViewController.h"
#import "ThemeManager.h"
#import "SkinStyle.h"

#define NAVBAR_CHANGE_POINT 50
#define TABLE_HEADER_VIEW_HEIGHT 34
#define TABLE_VIEW_CELL_HEIGHT 82
#define PROGRESS_THRESHOLD 60

#define REUSE_TABLE_VIEW_CELL @"REUSE_TABLE_VIEW_CELL"
#define REUSE_TABLE_Header_VIEW_CELL @"REUSE_TABLE_Header_VIEW_CELL"

static const CGFloat TestViewControllerHeadScrollHeight = 190.0f;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) HomeTopNewsCircularView *circularView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak, readonly) NSMutableArray<NSArray *> *newsArray;
@property (nonatomic, weak, readonly) NSArray<TopNewsResponseModel *> *topNewsArray;
@property (nonatomic, weak, readonly) HomePageDataManager *homePageDataManager;
@property (nonatomic, strong) NavBarView *navBarView;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int navBarViewBGColor;

@end

@implementation HomePageViewController

SYNTHESIZE_SINGLETON_FOR_CLASS(HomePageViewController)

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
    [self.view setClipsToBounds:YES];

    self.navigationController.delegate = self;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIPanGestureRecognizer *edge = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeftEdge:)];
    edge.delegate = self;
    [self.navigationController.view addGestureRecognizer:edge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavBarNightMode) name:kThemeDidChangeNotification object:nil];
    [self handleNavBarNightMode];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_circularView startTimerIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarTapNotification:) name:STATUS_BAR_TAP_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.newsArray.count > 0) {
        [_tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_circularView stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STATUS_BAR_TAP_NOTIFICATION object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

#pragma Observer Method

- (void)handleStatusBarTapNotification:(NSNotification *)notification{
    [_tableView setContentOffset:CGPointZero animated:YES];
}

- (void)handleNavBarNightMode{
    SkinStyle *skinStyle = nil;
    if ((skinStyle = [[ThemeManager sharedInstance] skinInstance])) {
        switch (skinStyle.skinID) {
            case 1:
                self.navBarViewBGColor = 0x2C74D3;
                break;
            case 2:
                self.navBarViewBGColor = 0x555555;
                break;
            default:
                break;
        }
        
        CGFloat yOffset  = _tableView.contentOffset.y;
        if (yOffset > 0) {
            if (yOffset > NAVBAR_CHANGE_POINT) {
                CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - yOffset) / 64));
                [UIView animateWithDuration:0.5 animations:^{
                   [_navBarView setBackgroundViewColor:UIColorFromRGBAndAlpha(self.navBarViewBGColor, alpha)];
                }];
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [_navBarView setBackgroundViewColor:UIColorFromRGBAndAlpha(self.navBarViewBGColor, 0)];
                }];
            }
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[PushAnimator alloc] init];
    
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

#pragma mark - Controller Transition

- (void)menuButtonClicked:(UIButton *)button{
    [self.sideMenuController showMenuViewController];
}

- (void)transitionToDetailNewsVC:(NSInteger)storyID section:(NSInteger)section{
    NewsDetailViewController *detailVC = [NewsDetailViewController new];
    detailVC.storyID = storyID;
    detailVC.section = section;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 *  @brief 解决与滑出菜单页的手势冲突
 *
 *  @param gestureRecognizer
 *
 *  @return
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.visibleViewController == [self.navigationController.viewControllers firstObject] || [self.navigationController.visibleViewController isKindOfClass:[ThemeDailyViewController class]]) {
        return NO;
    }
    
    return YES;
}

- (void)handleSwipeFromLeftEdge:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGPoint translate = [gesture translationInView:[UIApplication sharedApplication].delegate.window];
    CGFloat percent   = translate.x / self.view.bounds.size.width;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.interactionController updateInteractiveTransition:percent];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [gesture velocityInView:gesture.view];
        if (velocity.x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - Controller UI Init

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initUI{
    [self initTableView];
    [self initCircularView];
    
    self.navBarView = [NavBarView new];
    [_navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_navBarView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_navBarView)]];
    [_navBarView.leftButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:_tableView];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), TestViewControllerHeadScrollHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.themeMap = @{kThemeMapKeyColorName : @"table_bg"};
    
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:REUSE_TABLE_VIEW_CELL];
    [self.tableView registerClass:[HomeNewsTableHeaderView class] forHeaderFooterViewReuseIdentifier:REUSE_TABLE_Header_VIEW_CELL];
    
    self.tableView.rowHeight = TABLE_VIEW_CELL_HEIGHT;
}

- (void)initCircularView{
    
    self.circularView = [[HomeTopNewsCircularView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), TestViewControllerHeadScrollHeight + 20)];
    
    [self.view addSubview:_circularView];
}

#pragma mark - loadData Method

- (void)initData{
    WEAK_REF(self)
    
    [self.homePageDataManager getLatestNewsWithSuccess:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_)
        if (self__) {
            [self__.circularView setupDataForCollectionViewWithArray:self__.topNewsArray];
            
            self__.circularView.TapActionBlock = ^(MTLModel <MTLJSONSerializing> * indexModel){
                STRONG_REF(self_)
                if (self__) {
                    if ([indexModel isKindOfClass:[TopNewsResponseModel class]]) {
                        TopNewsResponseModel *topNewsModel = (TopNewsResponseModel *)indexModel;
                        [self__ transitionToDetailNewsVC:topNewsModel.storyID section:0];
                    }
                }
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
    
    [self transitionToDetailNewsVC:model.storyID section:indexPath.section];
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
            _isLoading = YES;
            [self initData];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isLoading = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        
        if (!_isLoading) {
            CGFloat progress = -yOffset / PROGRESS_THRESHOLD;
            [_navBarView updateProgress:progress];
        }
        
        CGRect f = self.circularView.frame;
        f.origin.y = 0;
        f.size.height = TestViewControllerHeadScrollHeight + 20 - yOffset;
        self.circularView.frame = f;
    }
    else{
        CGRect f = self.circularView.frame;
        f.origin.y = -yOffset;
        f.size.height = TestViewControllerHeadScrollHeight + 20;
        self.circularView.frame = f;
        
        [_navBarView setProgressViewHidden:YES];
        
        if (yOffset > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - yOffset) / 64));
            [_navBarView setBackgroundViewColor:UIColorFromRGBAndAlpha(self.navBarViewBGColor, alpha)];
        } else {
            [_navBarView setBackgroundViewColor:UIColorFromRGBAndAlpha(self.navBarViewBGColor, 0)];
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
}

@end
