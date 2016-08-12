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

@interface NewsDetailViewController ()

@property (nonatomic, strong) DetailNewsView *detailNewsView;
@property (nonatomic, weak) IBOutlet UIView *toolBarView;
@property (nonatomic, weak, readonly) HomePageDataManager *homePageDataManager;
@end

@implementation NewsDetailViewController

- (HomePageDataManager *)homePageDataManager{
    return [HomePageDataManager sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.detailNewsView = [[DetailNewsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 43)];
    [self.view addSubview:_detailNewsView];
    
    [self.view bringSubviewToFront:_toolBarView];
}

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

- (void)switchToNextStoryWithCurrentSection:(NSInteger *)section storyID:(NSInteger)storyID{
    NSInteger nextStoryID = [self.homePageDataManager getNextNewsWithSection:section currentID:storyID];
    
    if (nextStoryID != -1) {
        DetailNewsView *detailNewsView = [[DetailNewsView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 43)];
        
        [self.view addSubview:detailNewsView];
        
        DetailNewsView *previousDetailNewsView = _detailNewsView;
        
        _detailNewsView = detailNewsView;
        _storyID = nextStoryID;
        [self loadData];
        
        [UIView animateWithDuration:.5 animations:^{
            detailNewsView.top = 0;
            previousDetailNewsView.top = -kScreenHeight + 43;
        }completion:^(BOOL finished){
            [previousDetailNewsView removeFromSuperview];
        }];
    }

}

- (void)loadData{
    [[HTTPClient sharedInstance] getDetailNewsWithID:_storyID success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        DetailNewsResponseModel *detailNewsModel = (DetailNewsResponseModel *)model;
        [_detailNewsView updateNewsWithModel:detailNewsModel];
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
