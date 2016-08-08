//
//  CircularCollectionViewCell.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTLModel;
@protocol MTLJSONSerializing;

@interface CircularCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) MTLModel<MTLJSONSerializing> *model;

@end
