//
//  SkinStyle.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinStyle : NSObject

@property (nonatomic, assign) NSInteger skinID;
@property (nonatomic, copy) NSString *skinName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *pathPrefix;

- (id)initWithContentOfFile:(NSString *)filePath withPathPrefix:(NSString *)pathPrefix;
- (void)merge:(SkinStyle *)skinStyle;
- (NSString *)fullResourcePathForName:(NSString *)name;
- (NSString *)resourceForName:(NSString *)name;
- (UIColor *)colorForName:(NSString *)name;

@end
