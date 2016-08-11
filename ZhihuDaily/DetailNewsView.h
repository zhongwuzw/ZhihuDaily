//
//  DetailNewsView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailNewsResponseModel;

@interface DetailNewsView : UIView

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model;

@end
