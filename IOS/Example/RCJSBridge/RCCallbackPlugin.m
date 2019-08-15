//
//  RCCallbackPlugin.m
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/13.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import "RCCallbackPlugin.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation RCCallbackPlugin

- (void)callbackNumberFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackNumberFromNative");
    RCPluginResult* result = [RCPluginResult resultWithNumber:[NSNumber numberWithDouble:3.141] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)callbackStringFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackNumberFromNative");
    RCPluginResult* result = [RCPluginResult resultWithString:@"hello world!!" andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)callbackArrayFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackArrayFromNative");
    NSDictionary* dic = @{
                          @"a":@"dfdf",
                          @"b":@13
                          };
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:123],@"hello",dic, nil];
    RCPluginResult* result = [RCPluginResult resultWithArray:array andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)callbackObjFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackObjFromNative");
    NSDictionary* dic = @{
                          @"a":@"hello",
                          @"b":@"world"
                          };
    RCPluginResult* result = [RCPluginResult resultWithDictionary:dic andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)callbackArrayBufferFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackArrayBufferFromNative");
    NSString* str = @"hello android world";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"md5 : %@",[self getMd5Data:data]);
    RCPluginResult* result = [RCPluginResult resultWithArrayBuffer:data andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(NSString*)getMd5Data:(NSData*)data {
    //1: 创建一个MD5对象
    CC_MD5_CTX md5;
    //2: 初始化MD5
    CC_MD5_Init(&md5);
    //3: 准备MD5加密
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    //4: 准备一个字符串数组, 存储MD5加密之后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //5: 结束MD5加密
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    //6:从result数组中获取最终结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
}

- (void)callbackVoidFromNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call callbackVoidFromNative");
    RCPluginResult* result = [RCPluginResult resultWithVoid:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)keepCallbackFromString:(RCInvokedUrlCommand *)command {
    NSLog(@"call keepCallbackFromString");
    NSArray<NSString*> *lists = [NSArray arrayWithObjects:@"hello",@"world",@"from",@"java",@"script",nil];
    for (NSString* str in lists) {
        RCPluginResult* result = [RCPluginResult resultWithString:str andStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId keepCallback:YES];
        [NSThread sleepForTimeInterval:3];
    }
    RCPluginResult* result = [RCPluginResult resultWithString:@"done" andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId keepCallback:NO];
}

@end
