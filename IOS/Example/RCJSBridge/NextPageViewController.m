//
//  NextPageViewController.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/20.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "NextPageViewController.h"
#import <WebKit/WebKit.h>
#import <RCJSBridge/RCJSBridge-umbrella.h>
#import "EchoPlugin.h"
#import "InputPlugin.h"
#import "plugins/TestPlugin1.h"
#import "plugins/TestPlugin2.h"
#import "plugins/TestPlugin3.h"
#import "plugins/TestPlugin4.h"
#import "plugins/TestPlugin5.h"

@interface NextPageViewController (){
@private
    RCWebViewBridge* _webViewEngine;
@private
    WKWebView* _wkWebView;
@private
    WKWebViewConfiguration* _configuration;
}

@end

@implementation NextPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _configuration = [[WKWebViewConfiguration alloc]init];
    //  WKUserContentController* controller = [[WKUserContentController alloc]init];
    _wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:_configuration];
    _webViewEngine = [[RCWebViewBridge alloc]initWithWkWebView:_wkWebView];
    EchoPlugin* echoPlugin = [[EchoPlugin alloc] initWithViewController:self];
    InputPlugin* inputPlugin = [[InputPlugin alloc] init];
    TestPlugin1* plugin1 = [[TestPlugin1 alloc] init];
    TestPlugin2* plugin2 = [[TestPlugin2 alloc] init];
    TestPlugin3* plugin3 = [[TestPlugin3 alloc] init];
    TestPlugin4* plugin4 = [[TestPlugin4 alloc] init];
    TestPlugin5* plugin5 = [[TestPlugin5 alloc] init];
    [_webViewEngine registerPlugin:echoPlugin];
    [_webViewEngine registerPlugin:inputPlugin];
    [_webViewEngine registerPlugin:plugin1];
    [_webViewEngine registerPlugin:plugin2];
    [_webViewEngine registerPlugin:plugin3];
    [_webViewEngine registerPlugin:plugin4];
    [_webViewEngine registerPlugin:plugin5];
    [self.view addSubview:_wkWebView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil inDirectory:@"www/main"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_wkWebView loadRequest:request];
}

- (void)viewDidDisappear:(BOOL)animated {
   [_webViewEngine dispose];
}

- (void)dealloc
{
    NSLog(@"call dealloc NextPageViewController 销毁");
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
