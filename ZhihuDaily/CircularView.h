//
//  CircularCollectionView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTLModel;
@protocol MTLJSONSerializing;

@interface CircularView : UIView

@property (nonatomic , copy) void (^TapActionBlock)(MTLModel <MTLJSONSerializing> * indexModel);
@property (nonatomic, strong) NSMutableArray<MTLModel<MTLJSONSerializing> *> *dataArray;

-(void)setupDataForCollectionViewWithArray:(NSArray <MTLModel<MTLJSONSerializing> *> *)array;

@end
