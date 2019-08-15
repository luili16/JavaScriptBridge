//
//  RCTestPlugin.h
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/13.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import <RCJSBridge/RCPlugin.h>
#import <RCInvokedUrlCommand.h>
NS_ASSUME_NONNULL_BEGIN

@interface RCTestPlugin : RCPlugin
-(void)passNumberToNative:(RCInvokedUrlCommand*)command;
-(void)passStringToNative:(RCInvokedUrlCommand*)command;
-(void)passBooleanToNative:(RCInvokedUrlCommand*)command;
-(void)passArrayToNative:(RCInvokedUrlCommand*)command;
-(void)passObjectToNative:(RCInvokedUrlCommand*)command;
-(void)passNullToNative:(RCInvokedUrlCommand*)command;
-(void)passEmptyToNative:(RCInvokedUrlCommand*)command;
-(void)passArrayBufToNative:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
