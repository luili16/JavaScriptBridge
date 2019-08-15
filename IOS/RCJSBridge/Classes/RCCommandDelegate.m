//
//  RCCommandDelegate.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/16.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCCommandDelegate.h"

@interface RCCommandDelegate() {
    @private
    WKWebView* _wkWebView;
}
@end

@implementation RCCommandDelegate
@synthesize wkWebView = _wkWebView;
-(RCCommandDelegate *)initWithWebView:(WKWebView*)webView {
    self = [super init];
    if (self) {
        _wkWebView = webView;
    }
    return self;
}

- (void)sendPluginResult:(RCPluginResult *)pluginResult callbackId:(NSString *)callbackId {
    [self sendPluginResult:pluginResult callbackId:callbackId keepCallback:NO];
}

- (void)sendPluginResult:(RCPluginResult *)pluginResult callbackId:(NSString *)callbackId keepCallback:(BOOL)keepCallback {
    int status = [pluginResult.status intValue];
    NSString* argumentsAsJson = [pluginResult argumentsAsJson];
    NSString* js = [NSString stringWithFormat:@"window.RCJSBridge.nativeCallback('%@',%d,%d,%@);",callbackId,status,keepCallback,argumentsAsJson];
    [self evalJs:js];
}

- (void)evalJs:(NSString *)js {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_wkWebView != nil) {
            [self->_wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"ERROR: %@",error);
                }
            }];
        } else {
            NSLog(@"wkWebView has been destroied!");
        }
    });
}
-(void)dispose {
    NSLog(@"dispose");
    _wkWebView = nil;
}
@end
