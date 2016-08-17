//
//  HTTPURLConfiguration.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPURLConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *latestNews;
@property (nonatomic, copy, readonly) NSString *previousNews;
@property (nonatomic, copy, readonly) NSString *detailNews;
@property (nonatomic, copy, readonly) NSString *themesList;
@property (nonatomic, copy, readonly) NSString *theme;
@property (nonatomic, copy, readonly) NSString *launchImage;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HTTPURLConfiguration)

@end
