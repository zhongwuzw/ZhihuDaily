//
//  ThemeDetailViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/17.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "ThemeDailyDataManager.h"
#import "ThemeDailyView.h"
#import "DetailNewsResponseModel.h"

#import <TOWebViewController.h>

@interface ThemeDetailViewController () <SwitchNewsDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (nonatomic, weak, readonly) ThemeDailyDataManager *themeDailyDataManager;
@property (nonatomic, strong) ThemeDailyView *detailNewsView;

@end

@implementation ThemeDetailViewController

- (ThemeDailyDataManager *)themeDailyDataManager{
    return [ThemeDailyDataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarTapNotification:) name:STATUS_BAR_TAP_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STATUS_BAR_TAP_NOTIFICATION object:nil];
}

#pragma Observer Method

- (void)handleStatusBarTapNotification:(NSNotification *)notification{
    [_detailNewsView setContentOffset:CGPointZero animated:YES];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.detailNewsView = [[ThemeDailyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 43)];
    _detailNewsView.delegate = self;
    
    [self.view insertSubview:_detailNewsView belowSubview:_toolBarView];
}

- (void)initData{
    [[HTTPClient sharedInstance] getDetailNewsWithID:_storyID success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        DetailNewsResponseModel *detailNewsModel = (DetailNewsResponseModel *)model;
        [_detailNewsView updateNewsWithModel:detailNewsModel];
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        ;
    }];
}

#pragma mark - ToolBar Clicked Handle

- (IBAction)handleToolbarButtonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self switchToNextStoryWithStoryID:_storyID];
            break;
        default:
            break;
    }
}

#pragma mark - Previous/Next News Switch Method

- (void)switchToNextStoryWithStoryID:(NSInteger)storyID{
    NSInteger nextStoryID = [self.themeDailyDataManager getNextNewsWithCurrentID:storyID];
    
    if (nextStoryID != -1) {
        ThemeDailyView *detailNewsView = [[ThemeDailyView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 43)];

        detailNewsView.delegate = self;
        
        [self.view insertSubview:detailNewsView belowSubview:_toolBarView];
        
        ThemeDailyView *previousDetailNewsView = _detailNewsView;
        
        _detailNewsView = detailNewsView;
        _storyID = nextStoryID;
        [self initData];
        
        [UIView animateWithDuration:.5 animations:^{
            detailNewsView.top = 0;
            previousDetailNewsView.top = -kScreenHeight + 43;
        }completion:^(BOOL finished){
            [previousDetailNewsView removeFromSuperview];
        }];
    }
    
}

- (void)switchToPreviousStoryWithStoryID:(NSInteger)storyID{
    NSInteger nextStoryID = [self.themeDailyDataManager getPreviousNewsWithCurrentID:storyID];
    
    if (nextStoryID != -1) {
        ThemeDailyView *detailNewsView = [[ThemeDailyView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight - 43)];
        
        detailNewsView.delegate = self;
        
        [self.view insertSubview:detailNewsView belowSubview:_toolBarView];
        
        ThemeDailyView *previousDetailNewsView = _detailNewsView;
        
        _detailNewsView = detailNewsView;
        _storyID = nextStoryID;
        [self initData];
        
        [UIView animateWithDuration:.5 animations:^{
            detailNewsView.top = 0;
            previousDetailNewsView.top = kScreenHeight;
        }completion:^(BOOL finished){
            [previousDetailNewsView removeFromSuperview];
        }];
    }
    
}

#pragma mark - SwitchNewsDelegate Method

- (void)switchToPreviousNews{
    [self switchToPreviousStoryWithStoryID:_storyID];
}

- (void)switchToNextNews{
    [self switchToNextStoryWithStoryID:_storyID];
}

- (void)handleWebViewClickedWithURL:(NSURL *)url{
    TOWebViewController *safariVC = [[TOWebViewController alloc] initWithURL:url];
    safariVC.showUrlWhileLoading = NO;
    
    [self.navigationController pushViewController:safariVC animated:YES];
    [safariVC.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
