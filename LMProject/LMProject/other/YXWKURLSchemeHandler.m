//
//  YXWKURLSchemeHandler.m
//  LMProject
//
//  Created by zhanglimin on 2024/8/7.
//

#import "YXWKURLSchemeHandler.h"
#import "YXNetworkManager.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>

@interface YXWKURLSchemeHandler ()

@property (nonatomic, strong) NSMutableSet * schemeTaskSet;

@end

@implementation YXWKURLSchemeHandler

- (void) webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    // 防止对已经stoped的task发送消息 会报错："This task has already been stopped"
    [self.schemeTaskSet addObject:urlSchemeTask];
    
    NSURLRequest * request = urlSchemeTask.request;
    NSString * urlStr = request.URL.absoluteString;
    NSString * method = urlSchemeTask.request.HTTPMethod;
    NSData * bodyData = urlSchemeTask.request.HTTPBody;
    NSDictionary * bodyDict = nil;
    
    if (bodyData) {
        bodyDict = [NSJSONSerialization JSONObjectWithData:bodyData options:kNilOptions error:nil];
    }
    
    NSLog(@"拦截urlStr=%@", urlStr);
    NSLog(@"拦截method=%@", method);
    NSLog(@"拦截bodyData=%@", bodyData);
    
    // 检查图片缓存
    if ([urlStr hasSuffix:@".jpg"] || [urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".gif"]) {
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString * cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:request.URL];
        BOOL isExist = [imageCache diskImageDataExistsWithKey:cacheKey];
        if (isExist) {
            NSData * imgData = [[SDImageCache sharedImageCache] diskImageDataForKey:cacheKey];
            if ([self.schemeTaskSet containsObject:urlSchemeTask]) {
                [urlSchemeTask didReceiveResponse:[[NSURLResponse alloc] initWithURL:request.URL MIMEType:[self createMIMETypeForExtension:[urlStr pathExtension]] expectedContentLength:-1 textEncodingName:nil]];
                [urlSchemeTask didReceiveData:imgData];
                [urlSchemeTask didFinish];
                [self.schemeTaskSet removeObject:urlSchemeTask];
                return;
            }
        }
        [[SDWebImageManager sharedManager] loadImageWithURL:request.URL options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
    }
    
    // 检查网络请求缓存
    NSData * cachedData = (NSData *)[YXNetworkCache httpCacheForURL:urlStr parameters:bodyDict];
    if (cachedData) {
        NSHTTPURLResponse * response = [self createHTTPURLResponseForRequest:urlSchemeTask.request];
        if ([self.schemeTaskSet containsObject:urlSchemeTask]) {
            [urlSchemeTask didReceiveResponse:response];
            [urlSchemeTask didReceiveData:cachedData];
            [urlSchemeTask didFinish];
            [self.schemeTaskSet removeObject:urlSchemeTask];
            return;
        }
    }
    
    // 无缓存时发起网络请求（实际应用时需根据实际情况判断是否每个接口都要缓存）
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self.schemeTaskSet containsObject:urlSchemeTask]) {
            if (error) {
                [urlSchemeTask didFailWithError:error];
            } else {
                [YXNetworkCache setHttpCache:data URL:urlStr parameters:bodyDict];
                [urlSchemeTask didReceiveResponse:response];
                [urlSchemeTask didReceiveData:data];
                [urlSchemeTask didFinish];
            }
            [self.schemeTaskSet removeObject:urlSchemeTask];
        }
    }];
    [dataTask resume];
} /* webView */

- (NSHTTPURLResponse *) createHTTPURLResponseForRequest:(NSURLRequest *)request {
    // Determine the content type based on the request
    NSString * contentType;
    
    if ([request.URL.pathExtension isEqualToString:@"css"]) {
        contentType = @"text/css";
    } else if ([[request valueForHTTPHeaderField:@"Accept"] isEqualToString:@"application/javascript"]) {
        contentType = @"application/javascript;charset=UTF-8";
    } else {
        contentType = @"text/html;charset=UTF-8"; // default content type
    }
    
    // Create the HTTP URL response with the dynamic content type
    NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{ @"Content-Type": contentType }];
    
    return response;
}


- (NSString *) createMIMETypeForExtension:(NSString *)extension {
    if (!extension || extension.length == 0) {
        return @"";
    }
    
    NSDictionary * MIMEDict = @{
        @"txt"  : @"text/plain",
        @"html" : @"text/html",
        @"htm"  : @"text/html",
        @"css"  : @"text/css",
        @"js"   : @"application/javascript",
        @"json" : @"application/json",
        @"xml"  : @"application/xml",
        @"swf"  : @"application/x-shockwave-flash",
        @"flv"  : @"video/x-flv",
        @"png"  : @"image/png",
        @"jpg"  : @"image/jpeg",
        @"jpeg" : @"image/jpeg",
        @"gif"  : @"image/gif",
        @"bmp"  : @"image/bmp",
        @"ico"  : @"image/vnd.microsoft.icon",
        @"woff" : @"application/x-font-woff",
        @"woff2": @"application/x-font-woff",
        @"ttf"  : @"application/x-font-ttf",
        @"otf"  : @"application/x-font-opentype"
    };
    
    NSString * MIMEType = MIMEDict[extension.lowercaseString];
    if (!MIMEType) {
        return @"";
    }
    
    return MIMEType;
} /* MIMETypeForExtension */

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSLog(@"stop = %@", urlSchemeTask);
    [self.schemeTaskSet removeObject:urlSchemeTask];
}

#pragma mark - lazy
- (NSMutableSet *) schemeTaskSet {
    if (!_schemeTaskSet) {
        _schemeTaskSet = [NSMutableSet set];
    }
    return _schemeTaskSet;
}

@end
