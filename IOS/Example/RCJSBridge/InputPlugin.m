//
//  InputPlugin.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/20.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "InputPlugin.h"

@implementation InputPlugin

- (void)pluginInitialize {
    NSLog(@"InputPlugin pluginInitialize");
}

- (void)dispose {
    NSLog(@"InputPluin:dispose");
}

- (void)NSNumberArgument:(RCInvokedUrlCommand *)command {
    int arg0 = [(NSNumber*)command.arguments[0] intValue];
    NSInteger arg1 = [(NSNumber*)command.arguments[1] integerValue];
    double arg2 = [(NSNumber*)command.arguments[2] doubleValue];
    NSLog(@"NSNumberArgument->arg0: %d",arg0);
    NSLog(@"NSNumberArgument->arg1: %ld",arg1);
    NSLog(@"NSNumberArgument->arg2: %f",arg2);
}

- (void)StringArgument:(RCInvokedUrlCommand *)command {
    NSString* arg0 = command.arguments[0];
    NSLog(@"StringArguement->%@",arg0);
}

- (void)NSArrayArgument:(RCInvokedUrlCommand *)command {
    NSArray* arg0 = command.arguments[0];
    NSInteger val0 = [(NSNumber*)arg0[0] integerValue];
    NSString* val1 = arg0[1];
    double val2 = [(NSNumber*)arg0[2] doubleValue];
    NSLog(@"NSArrayArgument->val0:%ld",val0);
    NSLog(@"NSArrayArgument->val1:%@",val1);
    NSLog(@"NSArrayArgument->val2:%f",val2);
}

- (void)NSDictionaryArgument:(RCInvokedUrlCommand *)command {
    NSDictionary* arg0 = command.arguments[0];
    NSLog(@"NSDictionaryArgument->argo:%@",arg0);
}

- (void)NSDataArgument:(RCInvokedUrlCommand *)command {
    
}

- (void)NSNullArgument:(RCInvokedUrlCommand *)command {
    NSNull* nsnull = command.arguments[0];
    NSLog(@"NSNullArgument->arg0:%@",nsnull);
}

-(void)NSUndefinedArgument:(RCInvokedUrlCommand*)command {
    id ni=command.arguments[0];
    NSLog(@"NSUndefinedArgument->arg0:%@",ni);
}

- (void)defferCallback:(RCInvokedUrlCommand *)command {
    NSLog(@"延时15s");
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    NSLog(@"延时结束");
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"finish"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
