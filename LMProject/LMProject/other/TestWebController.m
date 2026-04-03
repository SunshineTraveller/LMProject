//
//  TestWebController.m
//  LMProject
//
//  Created by zhanglimin on 2024/8/7.
//

#import "TestWebController.h"

#import "YXWKURLSchemeHandler.h"
#import <WebKit/WebKit.h>

@interface TestWebController ()

@property (nonatomic,strong) WKWebView *wkWebView;

@end

@implementation TestWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     
     if let sourcePath = Bundle.main.path(forResource: "dist", ofType: nil) {
//            let url = URL(fileURLWithPath: sourcePath.appending("/index.html#/videoGuide"))
         let url = URL(fileURLWithPath: sourcePath.appending("/index.html#/device-tab"))
         if let urlStr = url.absoluteString.removingPercentEncoding {
             mallWebVC.urlString = urlStr
             print("LMTest: url = \(url)   urlstr=\(urlStr)")
         }
     }
     */

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"dist" ofType:nil];
//    NSURL *fileURL = [NSURL fileURLWithPath:[htmlPath stringByAppendingString:@"/index.html#/videoGuide"]];
    NSURL *fileURL = [NSURL fileURLWithPath:[htmlPath stringByAppendingString:@"/index.html#/device-tab"]];
    NSString *urlStr = fileURL.absoluteString.stringByRemovingPercentEncoding;
    if (urlStr.length > 0) {
        fileURL = [NSURL URLWithString:urlStr];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [self.wkWebView loadRequest:request];
    
    [self.view addSubview:self.wkWebView];

}

- (WKWebView *) wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        // 允许跨域访问
        [config setValue:@(true) forKey:@"allowUniversalAccessFromFileURLs"];
        
        // 自定义HTTPS请求拦截
        YXWKURLSchemeHandler * handler = [[YXWKURLSchemeHandler alloc] init];
        [config setURLSchemeHandler:handler forURLScheme:@"https"];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

@end
