//
//  ViewController.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/16.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <RCJSBridge/RCJSBridge-umbrella.h>
#import "RCTestPlugin.h"
#import "RCCallbackPlugin.h"

@interface ViewController () {
    @private
    RCWebViewBridge* _webViewEngine;
    @private
    WKWebView* _wkWebView;
    @private
    WKWebViewConfiguration* _configuration;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _configuration = [[WKWebViewConfiguration alloc]init];
    _wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:_configuration];
    _webViewEngine = [[RCWebViewBridge alloc]initWithWkWebView:_wkWebView];
    [_webViewEngine registerPlugin:[[RCTestPlugin alloc]init] withClassName:@"TestPlugin"];
    [_webViewEngine registerPlugin:[[RCCallbackPlugin alloc]init] withClassName:@"CallbackPlugin"];
    [self.view addSubview:_wkWebView];
    [_wkWebView setUIDelegate:self];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil inDirectory:@"www/main"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_wkWebView loadRequest:request];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)dealloc
{
    [_webViewEngine dispose];
}
@end
