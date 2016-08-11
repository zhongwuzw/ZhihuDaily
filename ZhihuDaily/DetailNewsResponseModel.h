//
//  DetailNewsResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/11.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DetailNewsResponseModel : MTLModel <MTLJSONSerializing>

@property (nonnull, copy, readonly) NSString *body;
@property (nonnull, copy, readonly) NSString *image_source;
@property (nonnull, copy, readonly) NSString *title;
@property (nonnull, copy, readonly) NSString *image;
@property (nonnull, copy, readonly) NSString *share_url;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *js;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *images;
@property (nonatomic, assign, readonly) NSInteger type;
@property (nonatomic, assign, readonly) NSInteger storyID;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *css;

@end
