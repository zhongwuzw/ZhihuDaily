//
//  ThemeDailyView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/17.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyView.h"
#import "DetailNewsResponseModel.h"

#define DetailHeaderViewHeight 210.0f

@interface ThemeDailyView () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DetailNewsResponseModel *newsModel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;

@end

@implementation ThemeDailyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.webView = [UIWebView new];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [self addSubview:_webView];
    
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];

    
    self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _previousButton.center = CGPointMake(kScreenWidth/2, -20);
    [_webView.scrollView addSubview:_previousButton];
    _previousButton.enabled = NO;
    [_previousButton setTitle:@"载入上一篇" forState:UIControlStateNormal];
    [_previousButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _previousButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_previousButton setImage:[UIImage imageNamed:@"ZHAnswerViewBackIcon"] forState:UIControlStateNormal];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _nextButton.center = CGPointMake(kScreenWidth/2, kScreenHeight + 20);
    [_webView.scrollView addSubview:_nextButton];
    _nextButton.enabled = NO;
    [_nextButton setTitle:@"载入下一篇" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_nextButton setImage:[UIImage imageNamed:@"ZHAnswerViewPrevIcon"] forState:UIControlStateNormal];
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
}

#pragma mark - Scrollview Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        
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
        if(scrollView.contentSize.height + 20 > _nextButton.centerY)
            _nextButton.centerY = scrollView.contentSize.height + 20;
        
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

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([self.delegate respondsToSelector:@selector(handleWebViewClickedWithURL:)]) {
            [self.delegate handleWebViewClickedWithURL:request.URL];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Dealloc Method

- (void)dealloc{
    DDLogDebug(@"DetailNewsView dealloc");
    _webView.delegate = nil;
    _webView = nil;
}

@end
