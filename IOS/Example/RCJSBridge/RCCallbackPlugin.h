//
//  RCCallbackPlugin.h
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/13.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import <RCJSBridge/RCPlugin.h>
#import <RCInvokedUrlCommand.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallbackPlugin : RCPlugin
-(void)callbackNumberFromNative:(RCInvokedUrlCommand*)command;
-(void)callbackStringFromNative:(RCInvokedUrlCommand*)command;
-(void)callbackArrayFromNative:(RCInvokedUrlCommand*)command;
-(void)callbackObjFromNative:(RCInvokedUrlCommand*)command;
-(void)callbackArrayBufferFromNative:(RCInvokedUrlCommand*)command;
-(void)callbackVoidFromNative:(RCInvokedUrlCommand*)command;
-(void)keepCallbackFromString:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
