//
//  DetailNewsView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "DetailNewsView.h"
#import "DetailNewsHeaderView.h"
#import "DetailNewsResponseModel.h"

#define DetailHeaderViewHeight 190.0f

@interface DetailNewsView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DetailNewsHeaderView *headerView;
@property (nonatomic, weak) NSLayoutConstraint *headerViewTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *headerViewHeightConstraint;
@property (nonatomic, strong) DetailNewsResponseModel *newsModel;

@end

@implementation DetailNewsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.webView = [UIWebView new];
    _webView.scrollView.delegate = self;
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_webView];
    
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    
    self.headerView = [DetailNewsHeaderView new];
    [self addSubview:_headerView];
    
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerView)]];
    
    self.headerViewTopConstraint = [NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:_headerViewTopConstraint];
    
    self.headerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:DetailHeaderViewHeight];
    
    [self addConstraint:_headerViewHeightConstraint];
}

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model{
    if ([model isEqual:_newsModel] || !model) {
        return;
    }
    
    self.newsModel = model;
    
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",[model.css firstObject],model.body] baseURL:nil];
    [_headerView updateNewsWithModel:model];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < 0) {
        [self.headerViewHeightConstraint setConstant:DetailHeaderViewHeight - yOffset];
    }
    else if(yOffset > 0){
        [self.headerViewTopConstraint setConstant:-yOffset];
    }
    else{
        [self.headerViewHeightConstraint setConstant:DetailHeaderViewHeight];
        [self.headerViewTopConstraint setConstant:0];
    }
    [_headerView setNeedsUpdateConstraints];
    [_headerView updateConstraintsIfNeeded];
}

@end
