//
//  ThemeEditorTableHeaderView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/16.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeEditorTableHeaderView.h"
#import "ThemeEditorResponseModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ThemeEditorTableHeaderView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *separatorLine;

@end

@implementation ThemeEditorTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.label = [UILabel new];
    [_label setText:@"主编"];
    [self addSubview:_label];
    
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    self.separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
    [self addSubview:_separatorLine];
    
    [_separatorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_separatorLine]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separatorLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
}

- (void)installEditorListWithArray:(NSArray<ThemeEditorResponseModel *> *)imageArray{
    __block CGFloat offset = 54;
    [imageArray enumerateObjectsUsingBlock:^(ThemeEditorResponseModel *obj, NSUInteger idx, BOOL *stop){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, 0, 24, 24)];
        imageView.centerY = self.centerY;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.avatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            UIGraphicsBeginImageContextWithOptions(imageView.size, NO, 0.0);
            [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:12] addClip];
            [image drawInRect:imageView.bounds];
            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
             }];
        [self addSubview:imageView];
        
        offset += 34;
    }];
}

@end
