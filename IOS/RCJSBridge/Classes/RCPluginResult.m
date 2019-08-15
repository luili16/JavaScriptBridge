//
//  RCPluginResult.m
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCPluginResult.h"
#import "RCJSON_private.h"

@interface RCPluginResult() {
    NSNumber* _status;
    id _message;
}
- (RCPluginResult*)initWithStatus:(RCCommandStatus)statusOrdinal message:(id)theMessage;
@end

@implementation RCPluginResult
@synthesize status = _status;
@synthesize message = _message;
id messageFromArrayBuffer(NSData* data)
{
    return @{
             @"CDVType" : @"ArrayBuffer",
             @"data" :[data base64EncodedStringWithOptions:0]
             };
}

id messageFromVoid() {
    return @{
             @"CDVType" : @"Void"
             };
}

-(RCPluginResult*)initWithStatus:(RCCommandStatus)statusOrdinal message:(_Nonnull id)theMessage {
    self = [super init];
    if (self) {
        _status = [NSNumber numberWithInt:statusOrdinal];
        _message = theMessage;
    }
    return self;
}

+ (RCPluginResult *)resultWithVoid:(RCCommandStatus)status {
    return [[RCPluginResult alloc]initWithStatus:status message:messageFromVoid()];
}

+ (RCPluginResult *)resultWithString:(NSString *)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:message];
}

+ (RCPluginResult *)resultWithNumber:(NSNumber *)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:message];
}

+ (RCPluginResult *)resultWithBoolean:(BOOL)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:[NSNumber numberWithBool:message]];
}

+ (RCPluginResult *)resultWithArray:(NSArray *)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:message];
}

+ (RCPluginResult *)resultWithDictionary:(NSDictionary *)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:message];
}

+ (RCPluginResult *)resultWithArrayBuffer:(NSData *)message andStatus:(RCCommandStatus)status {
    return [[RCPluginResult alloc] initWithStatus:status message:messageFromArrayBuffer(message)];
}

- (NSString *)argumentsAsJson {
    id arguments = (self.message == nil ? [NSNull null] : self.message);
    NSArray* argumentsWrappedInArray = [NSArray arrayWithObject:arguments];
    
    NSString* argumentsJSON = [argumentsWrappedInArray rc_JSONString];
    // 这里没有想清楚为什么要剥离外面的大括号
    //NSLog(@"argumetsJson before: %@",argumentsJSON);
    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];
    //NSLog(@"argumetsJson after: %@",argumentsJSON);
    return argumentsJSON;
}

@end
