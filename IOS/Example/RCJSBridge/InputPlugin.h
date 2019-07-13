//
//  InputPlugin.h
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/20.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <RCJSBridge/RCJSBridge-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputPlugin : RCPlugin
// NSNumber下可能的类型
-(void)NSNumberArgument:(RCInvokedUrlCommand*)command;
// ------------------------

// 传一个字符串
-(void)StringArgument:(RCInvokedUrlCommand*)command;
// 传一个数组
-(void)NSArrayArgument:(RCInvokedUrlCommand*)command;
// 传一个Dictionary
-(void)NSDictionaryArgument:(RCInvokedUrlCommand*)command;
// 传一个NSData
-(void)NSDataArgument:(RCInvokedUrlCommand*)command;
// 传一个NSNull
-(void)NSNullArgument:(RCInvokedUrlCommand*)command;

// 延时回调
-(void)defferCallback:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
