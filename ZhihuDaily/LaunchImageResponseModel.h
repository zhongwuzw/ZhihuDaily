//
//  LaunchImageResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/16.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LaunchImageResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *img;

@end
