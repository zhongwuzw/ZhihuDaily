//
//  ThemeDailyTableViewCell.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/16.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeDailyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ThemeDailyTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIImageView *separatorLine;
@property (nonatomic, weak) NSLayoutConstraint *imageWidthConstraint;

@end

@implementation ThemeDailyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.themeMap = @{kThemeMapKeyColorName : @"cell_text"};
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.rightImage = [UIImageView new];
    [self.contentView addSubview:_rightImage];
    
    [_rightImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-15-[_rightImage]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel,_rightImage)]];
    self.imageWidthConstraint = [NSLayoutConstraint constraintWithItem:_rightImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:68];
    [self.contentView addConstraint:_imageWidthConstraint];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:56]];
    
    self.separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
    [self.contentView addSubview:_separatorLine];
    
    [_separatorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_separatorLine]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separatorLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
}

- (void)setTitleLabel:(NSString *)title imageURL:(NSString *)imageURL{
    [_titleLabel setText:title];
    
    if (!imageURL) {
        [self.imageWidthConstraint setConstant:0];
    }
    else{
        [self.imageWidthConstraint setConstant:68];
        [_rightImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Image_Preview"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    }
}

@end
