//
//  SettingsTableViewCell.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/30.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "SettingsTableViewCell.h"
#import "UserConfig.h"

@interface SettingsTableViewCell ()

@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UIImageView *separatorLine;

@end

@implementation SettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    self.textLabel.themeMap = @{kThemeMapKeyColorName : @"cell_text"};
    
    self.switchControl = [UISwitch new];
    [self.contentView addSubview:_switchControl];
    [_switchControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_switchControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:centerYConstraint];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchControl]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_switchControl)]];
    
    [_switchControl addTarget:self action:@selector(switchControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    _switchControl.onTintColor = UIColorFromRGB(0x2C74D3);
    [_switchControl setOn:[[UserConfig sharedInstance] isBlockPicture]];
    
    self.separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
    [self.contentView addSubview:_separatorLine];
    
    [_separatorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_separatorLine]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separatorLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separatorLine)]];
}

- (void)switchControlChanged:(UISwitch *)swi{
    [[UserConfig sharedInstance] setIsBlockPicture:swi.on];
}

@end
