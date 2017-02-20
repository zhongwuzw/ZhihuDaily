//
//  NSString+Utils.h
//  ZhihuDaily
//
//  Created by 钟武 on 2017/2/20.
//  Copyright © 2017年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

- (NSString *)stringByReplacingPercentEscapes;
+ (NSString *)mimeTypeForPathExtension:(NSString *)pathExtension;

@end
