//
//  TestPlugin2.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/22.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "TestPlugin2.h"

@implementation TestPlugin2
- (void)pluginInitialize {
    NSLog(@"TestPlugin2 pluginInitialize");
}
- (void)echoString:(RCInvokedUrlCommand *)command {
    NSString* arg0 = command.arguments[0];
    NSLog(@"TestPlugin2 call echoString: arg0=%@",command.arguments[0]);
    [NSThread sleepForTimeInterval:3];
    NSArray* res = @[arg0,(NSNumber*)command.arguments[1]];
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:res];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
