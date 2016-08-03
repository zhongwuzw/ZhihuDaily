//
//  TopNewsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TopNewsResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *image;
@property (nonatomic, assign, readonly) NSInteger type;
@property (nonatomic, assign, readonly) NSInteger storyID;
@property (nonatomic, copy, readonly) NSString *title;

@end
