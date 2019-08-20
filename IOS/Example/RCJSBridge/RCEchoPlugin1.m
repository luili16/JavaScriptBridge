//
//  RCEchoPlugin1.m
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/20.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import "RCEchoPlugin1.h"
#import <RCInvokedUrlCommand.h>


@implementation RCEchoPlugin1
- (void)method0:(RCInvokedUrlCommand *)command {
    int val = (arc4random() % 2000) + 1;
    [NSThread sleepForTimeInterval:(val / 1000)];
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method1:(RCInvokedUrlCommand *)command {
    int val = (arc4random() % 2000) + 1;
    [NSThread sleepForTimeInterval:(val / 1000)];
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method2:(RCInvokedUrlCommand *)command {
    int val = (arc4random() % 2000) + 1;
    [NSThread sleepForTimeInterval:(val / 1000)];
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method3:(RCInvokedUrlCommand *)command {
    int val = (arc4random() % 2000) + 1;
    [NSThread sleepForTimeInterval:(val / 1000)];
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method4:(RCInvokedUrlCommand *)command {
    int val = (arc4random() % 2000) + 1;
    [NSThread sleepForTimeInterval:(val / 1000)];
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
