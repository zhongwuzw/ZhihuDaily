//
//  LaunchViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/16.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "LaunchViewController.h"
#import "BaseResponseModel.h"
#import "LaunchImageResponseModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *launchView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initData{
    NSString *resolution = [NSString stringWithFormat:@"%ld*%ld",(long)self.view.width,(long)self.view.height];
    
    WEAK_REF(self);
    [[HTTPClient sharedInstance] getLaunchImageWithResolution:resolution success:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_);
        if (self__) {
            LaunchImageResponseModel *launchModel = (LaunchImageResponseModel *)model;
            
            [self__.imageView sd_setImageWithURL:[NSURL URLWithString:launchModel.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                [UIView animateWithDuration:1.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self__.imageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    self__.launchView.alpha = 0;
                }completion:^(BOOL finished){
                    
                }];
            }];
        }
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
                                            
    }];
}

@end
