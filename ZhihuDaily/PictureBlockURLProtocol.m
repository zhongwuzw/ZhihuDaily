//
//  ZWHybridPackageProtocol.m
//  iOSSampleCode
//
//  Created by 钟武 on 16/6/29.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "PictureBlockURLProtocol.h"
#import "AppDelegate.h"
#import "UserConfig.h"
#import "NSString+Utils.h"

static NSString *const HybridResourceProtocolKey = @"HybridResourceProtocolKey";

@implementation PictureBlockURLProtocol

+ (BOOL)isBlockPictureDownload{
    Reachability *reachability = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).reachability;
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    BOOL isBlock = netStatus == ReachableViaWWAN?YES : NO;
    
    return isBlock;
}

/**
 *  @author 钟武, 16-06-29 18:06:47
 *
 *  @brief 如果返回NO，则request会进入默认的URL Loading System进行处理
 *
 *  @param request
 *
 *  @return
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:HybridResourceProtocolKey inRequest:request]) {
        return NO;
    }
    
    if ([[UserConfig sharedInstance] isBlockPicture] && ([request.URL.pathExtension caseInsensitiveCompare:@"jpg"] == NSOrderedSame || [request.URL.pathExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) && [self isBlockPictureDownload]) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSString *path = [[[self.request URL] path] stringByReplacingPercentEscapes];
    NSString *extention = [path pathExtension];
    NSString *mimeType = [NSString mimeTypeForPathExtension:extention];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL] MIMEType:mimeType expectedContentLength:0 textEncodingName:nil];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
}

@end
