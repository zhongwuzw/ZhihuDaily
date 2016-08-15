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
#import "NewsDetailViewController.h"

#define DetailHeaderViewHeight 210.0f

@interface DetailNewsView () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DetailNewsHeaderView *headerView;
@property (nonatomic, strong) DetailNewsResponseModel *newsModel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;

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
    
    self.headerView = [[DetailNewsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, DetailHeaderViewHeight)];
    [_webView.scrollView addSubview:_headerView];
    
    self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _previousButton.center = CGPointMake(kScreenWidth/2, -20);
    [_webView.scrollView addSubview:_previousButton];
    _previousButton.enabled = NO;
    [_previousButton setTitle:@"载入上一篇" forState:UIControlStateNormal];
    [_previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _previousButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_previousButton setImage:[UIImage imageNamed:@"ZHAnswerViewBack"] forState:UIControlStateNormal];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _nextButton.center = CGPointMake(kScreenWidth/2, kScreenHeight + 20);
    [_webView.scrollView addSubview:_nextButton];
    _nextButton.enabled = NO;
    [_nextButton setTitle:@"载入下一篇" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_nextButton setImage:[UIImage imageNamed:@"ZHAnswerViewPrevIcon"] forState:UIControlStateNormal];
    
    _webView.delegate = self;
}

- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated{
    [_webView.scrollView setContentOffset:point animated:animated];
}

#pragma mark - DataSource Method

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model{
    if ([model isEqual:_newsModel] || !model) {
        return;
    }
    
    self.newsModel = model;
    
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",[model.css firstObject],model.body] baseURL:nil];
    [_headerView updateNewsWithModel:model];
}

#pragma mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGRect f = _headerView.frame;
        f.origin.y = yOffset;
        f.size.height = DetailHeaderViewHeight - yOffset;
        _headerView.frame = f;
        
        if (yOffset <= -35) {
            [UIView animateWithDuration:.3 animations:^{
                _previousButton.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);

            }];
            
            if (yOffset < -40) {
                [scrollView setContentOffset:CGPointMake(0, -40) animated:NO];
            }
        }
        else{
            [UIView animateWithDuration:.3 animations:^{
                _previousButton.imageView.transform = CGAffineTransformIdentity;
                
            }];
        }
    }
    else{
        if (yOffset + kScreenHeight - 35 >= scrollView.contentSize.height + 40) {
            [UIView animateWithDuration:.3 animations:^{
                _nextButton.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
                
            }];
        }
        else
            [UIView animateWithDuration:.3 animations:^{
                _nextButton.imageView.transform = CGAffineTransformIdentity;
                
            }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat yoffset = scrollView.contentOffset.y;
    
    if (yoffset <= -35) {
        if ([self.delegate respondsToSelector:@selector(switchToPreviousNews)]) {
            [self.delegate switchToPreviousNews];
        }
    }
    else if (yoffset + kScreenHeight - 35 >= scrollView.contentSize.height + 40){
        if ([self.delegate respondsToSelector:@selector(switchToNextNews)]) {
            [self.delegate switchToNextNews];
        }
    }
}

#pragma mark - WebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _nextButton.center = CGPointMake(kScreenWidth/2, webView.scrollView.contentSize.height + 20);
}

#pragma mark - Dealloc Method

- (void)dealloc{
    DDLogDebug(@"DetailNewsView dealloc");
    _webView.delegate = nil;
    _webView = nil;
}

@end
