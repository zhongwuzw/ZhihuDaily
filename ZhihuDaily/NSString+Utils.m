//
//  NSString+Utils.m
//  ZhihuDaily
//
//  Created by 钟武 on 2017/2/20.
//  Copyright © 2017年 钟武. All rights reserved.
//

#import "NSString+Utils.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (Utils)

- (NSString *)stringByReplacingPercentEscapes
{
    NSString *string = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!string)
    {
        string = self;
        NSDictionary *percents = @{@"%21": @"!", @"%2A": @"*", @"%27": @"'", @"%28": @"(", @"%29": @")", @"%3B": @";", @"%3A": @":", @"%40": @"@", @"%26": @"&", @"%3D": @"=", @"%2B": @"+", @"%24": @"$", @"%2C": @",", @"%2F": @"/", @"%3F": @"?", @"%23": @"#", @"%5B": @"[", @"%5D": @"]", @"%20": @" ", @"%25": @"%", @"2D": @"-", @"%22": @"\"", @"%5C": @"\\"};
        for(NSString *key in [percents allKeys])
        {
            string = [string stringByReplacingOccurrencesOfString:key withString:percents[key]];
        }
    }
    return (string) ? string : self;
}

+ (NSString *)mimeTypeForPathExtension:(NSString *)pathExtension
{
    if(!pathExtension || !pathExtension.length)
    {
        return @"application/octet-stream";
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pathExtension, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!mimeType) {
        return @"application/octet-stream";
    }
    return (__bridge_transfer NSString *)mimeType;
}

@end
