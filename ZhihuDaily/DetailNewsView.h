//
//  DetailNewsView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailNewsResponseModel;
@class NewsDetailViewController;

@protocol SwitchNewsDelegate <NSObject>

- (void)switchToPreviousNews;
- (void)switchToNextNews;
- (void)handleWebViewClickedWithURL:(NSURL *)url;

@end

@interface DetailNewsView : UIView

@property (nonatomic, weak) id<SwitchNewsDelegate> delegate;

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model;
- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated;

@end
