//
//  RCCommandDelegate.h
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/16.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCPluginResult.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCommandDelegate : NSObject
@property(atomic,readonly) WKWebView* wkWebView;
-(RCCommandDelegate*)initWithWebView:(WKWebView*)wkWebView;
-(void)sendPluginResult:(RCPluginResult*)pluginResult callbackId:(NSString*)callbackId;
// keepCallback: true 通知js端不要删除这个callbackid，false 通知js端删除这个callbackid
-(void)sendPluginResult:(RCPluginResult *)pluginResult callbackId:(NSString *)callbackId keepCallback:(BOOL)keepCallback;
-(void)dispose;
@end

NS_ASSUME_NONNULL_END
