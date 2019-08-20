//
//  RCEchoPlugin0.m
//  RCJSBridge_Example
//
//  Created by 刘立新 on 2019/8/20.
//  Copyright © 2019 luili16@126.com. All rights reserved.
//

#import "RCEchoPlugin0.h"
@interface RCEchoPlugin0() {
    
}
@end
@implementation RCEchoPlugin0

- (void)method0:(RCInvokedUrlCommand *)command {
    NSNumber* arg0 = command.arguments[0];
    NSLog(@"arg0 : %ld",[arg0 integerValue]);
    int val = (arc4random() % 2000) + 1;
    NSLog(@"val is %d",val);
    [NSThread sleepForTimeInterval:(val / 1000)];
    NSLog(@"RCEchoPlugin0 callback method0");
    RCPluginResult* result = [RCPluginResult resultWithNumber:[NSNumber numberWithInteger:[arg0 integerValue]] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method1:(RCInvokedUrlCommand *)command {
    NSNumber* arg0 = command.arguments[0];
    NSLog(@"arg0 : %ld",[arg0 integerValue]);
    int val = (arc4random() % 2000) + 1;
    NSLog(@"val is %d",val);
    [NSThread sleepForTimeInterval:(val / 1000)];
    NSLog(@"RCEchoPlugin0 callback method1");
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method2:(RCInvokedUrlCommand *)command {
    NSNumber* arg0 = command.arguments[0];
    NSLog(@"arg0 : %ld",[arg0 integerValue]);
    int val = (arc4random() % 2000) + 1;
    NSLog(@"val is %d",val);
    [NSThread sleepForTimeInterval:(val / 1000)];
    NSLog(@"RCEchoPlugin0 callback method2");
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method3:(RCInvokedUrlCommand *)command {
    NSNumber* arg0 = command.arguments[0];
    NSLog(@"arg0 : %ld",[arg0 integerValue]);
    int val = (arc4random() % 2000) + 1;
    NSLog(@"val is %d",val);
    [NSThread sleepForTimeInterval:(val / 1000)];
    NSLog(@"RCEchoPlugin0 callback method3");
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)method4:(RCInvokedUrlCommand *)command {
    NSNumber* arg0 = command.arguments[0];
    NSLog(@"arg0 : %ld",[arg0 integerValue]);
    int val = (arc4random() % 2000) + 1;
    NSLog(@"val is %d",val);
    [NSThread sleepForTimeInterval:(val / 1000)];
    NSLog(@"RCEchoPlugin0 callback method4");
    RCPluginResult* result = [RCPluginResult resultWithNumber:command.arguments[0] andStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
