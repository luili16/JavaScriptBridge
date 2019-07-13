//
//  EchoPlugin.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/18.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "EchoPlugin.h"
#import "NextPageViewController.h"

@implementation EchoPlugin {
    NSData* _data;
    UIViewController* _controller;
}

-(EchoPlugin*)initWithViewController:(UIViewController*)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)pluginInitialize {
    NSLog(@"EchoPlugin pluginInitialize");
}

- (void)dispose {
    NSLog(@"EchoPlugin:dispose");
}

-(void)echoString:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoString: arguments at index 0-> %@",arguments0);
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:arguments0];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void)echoInt:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoInt: arguments at index 0 -> %@",arguments0);
    int message = (int)1234;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoMaxInt:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoMaxInt: arguments at index 0 -> %@",arguments0);
    int message = (int)2147483647;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoMinInt:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoMinInt: arguments at index 0 -> %@",arguments0);
    int message = (int)-2147483648;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoInteger:(RCInvokedUrlCommand *)command {
    [self echoNSInteger:command];
}

- (void)echoNSInteger:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoNSInteger: arguments at index 0 -> %@",arguments0);
    NSInteger message = (NSInteger)1234567;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoMaxInteger:(RCInvokedUrlCommand *)command {
    [self echoMaxNSInteger:command];
}

-(void)echoMaxNSInteger:(RCInvokedUrlCommand*)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"MaxNSInteger : %ld",NSIntegerMax);
    NSLog(@"echoMaxNSInteger: arguments at index 0 -> %@",arguments0);
    NSInteger message = NSIntegerMax;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoMinInteger:(RCInvokedUrlCommand*)command {
    [self echoMinNSInteger:command];
}

-(void)echoMinNSInteger:(RCInvokedUrlCommand*)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"MinNSInteger : %ld",NSIntegerMin);
    NSLog(@"echoMaxNSInteger: arguments at index 0 -> %@",arguments0);
    NSInteger message = NSIntegerMin;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoUInteger:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoUInteger: arguments at index 0-> %@",arguments0);
    NSUInteger message = (NSUInteger)1234;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSUInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoMaxUInteger:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoMaxUInteger: arguments at index 0-> %@",arguments0);
    NSUInteger message = NSUIntegerMax;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSUInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)echoMinUInteger:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoMinUInteger: arguments at index 0-> %@",arguments0);
    NSUInteger message = 0;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSUInteger:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoArray:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoArray: arguments at index 0-> %@",arguments0);
    //NSArray* message = @[@"helloworld",arguments0,@1234,@3.1415926];
    NSArray* message = @[@"abc",@"bcd",@"cdf",@"fgk"];
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoDouble:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoDouble: arguments at index 0-> %@",arguments0);
    double message = 3.1415926;
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoBool:(RCInvokedUrlCommand *)command {
    
}

- (void)echoDictionary:(RCInvokedUrlCommand *)command {
    NSString* arguments0 = command.arguments[0];
    NSLog(@"echoDictionary: arguments at index 0-> %@",arguments0);
    NSDictionary* message = @{
                                 @"anObject" : arguments0,
                                 @"helloString" : @"Hello, World!",
                                 @"magicNumber" : @42,
                                 @"aValue" : @3.1415926
                            };
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
// -------测试arraybuffer--------
- (void)echoArrayBuffer:(RCInvokedUrlCommand *)command {
    // 先将读取到的NSData发送回去
    NSString* fileName = command.arguments[0];
    NSString* path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSLog(@"path : %@",path);
    _data = [NSData dataWithContentsOfFile:path];
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:_data];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)diffArrayBuffer:(RCInvokedUrlCommand *)command {
    // 判断从js端发送回来的NSData是不是与传回去的一样
    NSData* data = command.arguments[0];
    BOOL isEquals =[_data isEqualToData:data];
    NSLog(@"data is equals: %@",(isEquals == YES?@"true":@"false"));
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isEquals];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
// ---------测试arraybuffer--------
- (void)echoMultipart:(RCInvokedUrlCommand *)command {
    
}

- (void)openNextPage:(RCInvokedUrlCommand *)command {
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NextPageViewController* controller = [story instantiateViewControllerWithIdentifier:@"NextPageId"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_controller.navigationController pushViewController:controller animated:YES];
    });
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)echoKeepCallback:(RCInvokedUrlCommand *)command {
    for (int i = 0; i < command.arguments.count; i++) {
        [NSThread sleepForTimeInterval:2.0];
        NSString* data = command.arguments[i];
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:data];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId keepCallback:(i == command.arguments.count-1?NO:YES)];
    }
}

- (void)echoBack:(RCInvokedUrlCommand *)command {
    
}

- (void)echoCallErrorCallback:(RCInvokedUrlCommand *)command {
    RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"this is an error msg"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
