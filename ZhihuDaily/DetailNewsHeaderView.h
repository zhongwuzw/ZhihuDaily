//
//  DetailNewsHeaderView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/11.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailNewsResponseModel;

@interface DetailNewsHeaderView : UIView

- (void)updateNewsWithModel:(DetailNewsResponseModel *)model;

@end
