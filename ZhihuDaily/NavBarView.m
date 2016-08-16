//
//  NavBarView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/5.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "NavBarView.h"
#import "CircleProgressView.h"

@interface NavBarView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CircleProgressView *progressView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation NavBarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.backgroundView = [UIView new];
    [self addSubview:_backgroundView];
    [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroundView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    self.backgroundHeightConstraint = [NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
    [self addConstraint:_backgroundHeightConstraint];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_leftButton];
    [_leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"Home_Icon_Highlight"] forState:UIControlStateHighlighted];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_leftButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftButton]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftButton)]];
    
    self.titleLabel = [UILabel new];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_titleLabel setText:@"今日热点"];
    
    [self addSubview:_titleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_leftButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.progressView = [CircleProgressView new];
    [self addSubview:_progressView];
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_progressView(20)]-3-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView,_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_progressView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
    
    self.activityView = [UIActivityIndicatorView new];
    [self addSubview:_activityView];
    
    [_activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_activityView(20)]-3-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activityView,_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_activityView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activityView)]];
}

- (void)setTitle:(NSString *)title{
    [_titleLabel setText:title];
}

- (void)setBackgroundViewColor:(UIColor *)color{
    _backgroundView.backgroundColor = color;
}

- (void)setTitleLabelHidden:(BOOL)hidden{
    _titleLabel.hidden = hidden;
}

- (void)updateProgress:(CGFloat)progress{
    if (_activityView.isAnimating) {
        return;
    }
    [_progressView setHidden:NO];
    [_progressView updateProgress:progress];
}

- (void)startActivityIndicator{
    [_progressView setHidden:YES];
    [_activityView startAnimating];
}

- (void)stopActivityIndicator{
    [_activityView stopAnimating];
}

- (BOOL)isActivityIndicatorAnimating{
    return _activityView.isAnimating;
}

- (void)setProgressViewHidden:(BOOL)hidden{
    [_progressView setHidden:hidden];
}

@end
