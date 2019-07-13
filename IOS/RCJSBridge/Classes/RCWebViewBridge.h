//
//  RCWebViewEngine.h
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "RCPlugin.h"
#import "RCCommandDelegate.h"
#import "RCInvokedUrlCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCWebViewBridge : NSObject {
}
-(RCWebViewBridge*)initWithWkWebView:(WKWebView*)wkWebView;

-(void)registerPlugin:(RCPlugin*)plugin;
-(void)registerPlugin:(RCPlugin*)plugin withClassName:(NSString*)className;
-(void)registerPlugins:(NSArray<RCPlugin*>*)plugins;
// 注册一个全局的Action，这样就不需要继承plugin来定义action，直接在代码里就可以使用，更加灵活
-(void)registerAction:(NSString*)action callback:(void(^)(RCInvokedUrlCommand*,RCCommandDelegate*))callback;
// 在适当的时机销毁这个WebViewBridge
-(void)dispose;

@end

NS_ASSUME_NONNULL_END
