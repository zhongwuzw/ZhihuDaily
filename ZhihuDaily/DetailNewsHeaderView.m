//
//  DetailNewsHeaderView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/11.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "DetailNewsHeaderView.h"
#import "DetailNewsResponseModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailNewsHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *imageSourceLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DetailNewsHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    [self setClipsToBounds:YES];
    self.imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    
    self.imageSourceLabel = [UILabel new];
    _imageSourceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _imageSourceLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_imageSourceLabel];
    
    [_imageSourceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageSourceLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageSourceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    
    self.titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_titleLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-4-[_imageSourceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel,_imageSourceLabel)]];
}

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _imageSourceLabel.text = model.image_source;
    _titleLabel.text = model.title;
}

- (void)setFrame:(CGRect)frame{
    if (self.frame.size.height != frame.size.width) {
        [self.imageView setNeedsUpdateConstraints];
        [self.imageView updateConstraintsIfNeeded];
    }
    [super setFrame:frame];
}

@end
