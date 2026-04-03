//
//  WKWebView+SchemeHandle.m
//  LMProject
//
//  Created by zhanglimin on 2024/8/7.
//

#import "WKWebView+SchemeHandle.h"

#import <objc/runtime.h>

@implementation WKWebView (SchemeHandle)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod1 = class_getClassMethod(self, @selector(handlesURLScheme:));
        Method swizzledMethod1 = class_getClassMethod(self, @selector(yxHandlesURLScheme:));
        method_exchangeImplementations(originalMethod1, swizzledMethod1);
    });
}

+ (BOOL) yxHandlesURLScheme:(NSString *)urlScheme {
    if ([urlScheme isEqualToString:@"http"] || [urlScheme isEqualToString:@"https"]) {
        return NO;
    } else {
        return [self handlesURLScheme:urlScheme];
    }
}

@end
