//
//  RCTestPlugin.m
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/13.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import "RCTestPlugin.h"
#import <RCPluginResult.h>

@implementation RCTestPlugin

- (void)passNumberToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passNumberToNative method");
    NSArray* args = command.arguments;
    
    NSNumber* arg0Int = args[0];
    NSNumber* arg1Double = args[1];
    NSNumber* arg2Long = args[2];
    NSNumber* arg3Long = args[3];
    NSString* retVal = [NSString stringWithFormat:@"%d-%f-%ld-%ld",[arg0Int intValue],[arg1Double doubleValue],[arg2Long longValue],[arg3Long longValue]];
    RCPluginResult* result = [RCPluginResult resultWithString:retVal andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passStringToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passStringToNative method");
    NSString* arg0 =  command.arguments[0];
    RCPluginResult* result = [RCPluginResult resultWithString:arg0 andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passBooleanToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passBooleanToNative method");
    BOOL arg0 = command.arguments[0];
    RCPluginResult* result = [RCPluginResult resultWithBoolean:arg0 andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passArrayToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passArrayToNative method");
    NSArray* array = command.arguments[0];
    NSString* arg0 = array[0];
    NSNumber* arg1 = array[1];
    NSNumber* arg2 = array[2];
    NSString* retVal = [NSString stringWithFormat:@"%@-%ld-%f",arg0,[arg1 integerValue],[arg2 doubleValue]];
    RCPluginResult* result = [RCPluginResult resultWithString:retVal andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passObjectToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passObjectToNative method");
    NSDictionary* obj = command.arguments[0];
    NSString* user = [obj objectForKey:@"user"];
    NSLog(@"user is %@",user);
    NSString* info = [obj objectForKey:@"info"];
    NSLog(@"info is %@",info);
    NSNumber* account =[obj objectForKey:@"account"];
    NSLog(@"account is %ld",[account integerValue]);
    NSDictionary* map = [obj objectForKey:@"map"];
    NSLog(@"map is %@",map);
    NSArray* array = [obj objectForKey:@"array"];
    NSLog(@"array is %@",array);
    RCPluginResult* result = [RCPluginResult resultWithDictionary:obj andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passNullToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passNullToNative method");
    NSString* arg0 = command.arguments[0];
    NSLog(@"arg0 : %@",arg0);
    RCPluginResult* result = [RCPluginResult resultWithString:arg0 andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passEmptyToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passEmptyToNative method");
    NSLog(@"arg size:%ld",command.arguments.count);
    RCPluginResult* result = [RCPluginResult resultWithString:@"success" andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)passArrayBufToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passArrayBufToNative method");
    NSString* base64 = command.arguments[0];
    NSData* data = command.arguments[1];
    NSString* js64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    NSLog(@"base64Fromjs:%@",base64);
    NSLog(@"base64FromNative:%@",js64);
    BOOL equal = [base64 isEqualToString:js64];
    RCPluginResult* result = [RCPluginResult resultWithBoolean:equal andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
