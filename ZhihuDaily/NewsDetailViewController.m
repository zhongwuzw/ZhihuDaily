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

@interface NewsDetailViewController ()

@property (nonatomic, strong) DetailNewsView *detailNewsView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.detailNewsView = [DetailNewsView new];
    _detailNewsView.backgroundColor = [UIColor blackColor];
    [_detailNewsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_detailNewsView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_detailNewsView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailNewsView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_detailNewsView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailNewsView)]];
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
