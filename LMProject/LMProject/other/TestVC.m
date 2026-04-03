//
//  TestVC.m
//  LMProject
//
//  Created by zhanglimin on 2023/12/4.
//

#import "TestVC.h"

#import <WebKit/WebKit.h>

@interface TestVC ()
@property (atomic,assign) NSInteger index;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.cyanColor;
    
//    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    _webView.backgroundColor = UIColor.whiteColor;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://o8xrtz.xinstall.com.cn/tolink/"]]];
////    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://o8xrtz.xinstall.com.cn/tolink/share/xhs615169f016fc51b1ef5883ca1f494199?error_code=0&error_state=-10000000&error_string=ok&from_platform=xiaohongshu&from_platform_version=8.40&request_id=64b2d2a71443f2645407d1de723484ff&response_id=1718698988.347887&start_share_timestamp=1717663754608"]]];
////    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://test-api.edstars.com.cn/title=1&userInfo=123"]]];
//    [self.view addSubview:_webView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    static NSString *str = @"";
//    self.index += 1;
//    str = [NSString stringWithFormat:@"%ld",(long)self.index];
//    NSLog(@"lmtest: str =  %@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"talfamilyapp://test"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
