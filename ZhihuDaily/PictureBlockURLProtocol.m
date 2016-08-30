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

static NSString *const HybridResourceProtocolKey = @"HybridResourceProtocolKey";

@interface PictureBlockURLProtocol ()<NSURLConnectionDataDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong)NSURLConnection *connection;

@end

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
//        NSMutableURLRequest *newRequest = [self.request mutableCopy];
//        newRequest.allHTTPHeaderFields = self.request.allHTTPHeaderFields;
//        
//        [NSURLProtocol setProperty:@YES forKey:HybridResourceProtocolKey inRequest:newRequest];
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
//        [[session dataTaskWithRequest:newRequest] resume];

        //使用NSURLSession替换NSURLConnection
//        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark -NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark -NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }
    else
        [self.client URLProtocolDidFinishLoading:self];
}

@end
