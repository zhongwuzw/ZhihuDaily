//
//  NewsDetailViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "DetailNewsView.h"
#import "HTTPClient.h"
#import "BaseResponseModel.h"
#import "HomePageDataManager.h"

#import <TOWebViewController.h>

@interface NewsDetailViewController () <SwitchNewsDelegate>

@property (nonatomic, strong) DetailNewsView *detailNewsView;
@property (nonatomic, weak) IBOutlet UIView *toolBarView;
@property (nonatomic, weak, readonly) HomePageDataManager *homePageDataManager;
@end

@implementation NewsDetailViewController

- (HomePageDataManager *)homePageDataManager{
    return [HomePageDataManager sharedInstance];
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
    
    self.detailNewsView = [[DetailNewsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 43)];
    _detailNewsView.delegate = self;

    [self.view insertSubview:_detailNewsView belowSubview:_toolBarView];
}

- (void)initData{
    WEAK_REF(self);
    [[HTTPClient sharedInstance] getDetailNewsWithID:_storyID success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_);
        if (self__) {
            DetailNewsResponseModel *detailNewsModel = (DetailNewsResponseModel *)model;
            [self__.detailNewsView updateNewsWithModel:detailNewsModel];
        }
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
            [self switchToNextStoryWithCurrentSection:&_section storyID:_storyID];
            break;
        default:
            break;
    }
}

#pragma mark - Previous/Next News Switch Method

- (void)switchToNextStoryWithCurrentSection:(NSInteger *)section storyID:(NSInteger)storyID{
    NSInteger nextStoryID = [self.homePageDataManager getNextNewsWithSection:section currentID:storyID];
    
    if (nextStoryID != -1) {
        DetailNewsView *detailNewsView = [[DetailNewsView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 43)];
        
        detailNewsView.delegate = self;
    
        [self.view insertSubview:detailNewsView belowSubview:_toolBarView];
        
        DetailNewsView *previousDetailNewsView = _detailNewsView;
        
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

- (void)switchToPreviousStoryWithCurrentSection:(NSInteger *)section storyID:(NSInteger)storyID{
    NSInteger nextStoryID = [self.homePageDataManager getPreviousNewsWithSection:section currentID:storyID];
    
    if (nextStoryID != -1) {
        DetailNewsView *detailNewsView = [[DetailNewsView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight - 43)];
        
        detailNewsView.delegate = self;
        
        [self.view insertSubview:detailNewsView belowSubview:_toolBarView];
        
        DetailNewsView *previousDetailNewsView = _detailNewsView;
        
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
    [self switchToPreviousStoryWithCurrentSection:&_section storyID:_storyID];
}

- (void)switchToNextNews{
    [self switchToNextStoryWithCurrentSection:&_section storyID:_storyID];
}

- (void)handleWebViewClickedWithURL:(NSURL *)url{
    TOWebViewController *safariVC = [[TOWebViewController alloc] initWithURL:url];
    safariVC.showUrlWhileLoading = NO;
    
    [self.navigationController pushViewController:safariVC animated:YES];
    [safariVC.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
