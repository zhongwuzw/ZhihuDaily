//
//  NewsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NewsResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray<NSString *> *images;
@property (nonatomic, assign, readonly) NSInteger type;
@property (nonatomic, assign, readonly) NSInteger storyID;
@property (nonatomic, copy, readonly) NSString *title;

@end
