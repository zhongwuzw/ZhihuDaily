//
//  NewsListResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/10.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@class NewsResponseModel;

@interface NewsListResponseModel : MTLModel <MTLJSONSerializing>

@property (nonnull, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly, nullable) NSArray<NewsResponseModel *> *stories;

@end
