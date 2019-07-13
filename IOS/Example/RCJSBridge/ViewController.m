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
#import "EchoPlugin.h"
#import "InputPlugin.h"

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
  //  WKUserContentController* controller = [[WKUserContentController alloc]init];
    _wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:_configuration];
    _webViewEngine = [[RCWebViewBridge alloc]initWithWkWebView:_wkWebView];
    EchoPlugin* echoPlugin = [[EchoPlugin alloc] initWithViewController:self];
    InputPlugin* inputPlugin = [[InputPlugin alloc] init];
    [_webViewEngine registerPlugin:echoPlugin];
    [_webViewEngine registerPlugin:inputPlugin];
    [self.view addSubview:_wkWebView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil inDirectory:@"www/default"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_wkWebView loadRequest:request];
    
    [_webViewEngine registerAction:@"customAction" callback:^(RCInvokedUrlCommand * _Nonnull command, RCCommandDelegate * _Nonnull delegate) {
        NSString* arg0 = command.arguments[0];
        NSNumber* arg1 = command.arguments[1];
        NSNumber* arg2 = command.arguments[2];
        NSLog(@"arg0: %@, arg1:%d, arg2:%f",arg0,[arg1 intValue],[arg2 doubleValue]);
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call Custom Action success"];
        [delegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
    [_webViewEngine registerAction:@"customAction1" callback:^(RCInvokedUrlCommand * _Nonnull command, RCCommandDelegate * _Nonnull delegate) {
        NSString* arg0 = command.arguments[0];
        NSNumber* arg1 = command.arguments[1];
        NSNumber* arg2 = command.arguments[2];
        NSLog(@"arg0: %@, arg1:%d, arg2:%f",arg0,[arg1 intValue],[arg2 doubleValue]);
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call Custom Action1 success"];
        [delegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
    [_webViewEngine registerAction:@"customAction2" callback:^(RCInvokedUrlCommand * _Nonnull command, RCCommandDelegate * _Nonnull delegate) {
        NSString* arg0 = command.arguments[0];
        NSNumber* arg1 = command.arguments[1];
        NSNumber* arg2 = command.arguments[2];
        NSLog(@"arg0: %@, arg1:%d, arg2:%f",arg0,[arg1 intValue],[arg2 doubleValue]);
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"call Custom Action1 failed"];
        [delegate sendPluginResult:result callbackId:command.callbackId];
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)dealloc
{
    [_webViewEngine dispose];
}
@end
