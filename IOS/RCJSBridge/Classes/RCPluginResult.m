//
//  RCPluginResult.m
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCPluginResult.h"
#import "RCJSON_private.h"

@interface RCPluginResult()
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

id massageMessage(id message)
{
    if ([message isKindOfClass:[NSData class]]) {
        return messageFromArrayBuffer(message);
    }
    return message;
}

id messageFromMultipart(NSArray* theMessages)
{
    NSMutableArray* messages = [NSMutableArray arrayWithArray:theMessages];
    
    for (NSUInteger i = 0; i < messages.count; ++i) {
        [messages replaceObjectAtIndex:i withObject:massageMessage([messages objectAtIndex:i])];
    }
    
    return @{
             @"CDVType" : @"MultiPart",
             @"messages" : messages
             };
}

+(id) message {
    return nil;
}

-(RCPluginResult*)init {
    return [self initWithStatus:CDVCommandStatus_NO_RESULT message:nil];
}

-(RCPluginResult*)initWithStatus:(RCCommandStatus)statusOrdinal message:(id)theMessage {
    self = [super init];
    if (self) {
        _status = [NSNumber numberWithInt:statusOrdinal];
        _message = theMessage;
    }
    return self;
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal
{
    return [[self alloc] initWithStatus:statusOrdinal message:nil];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsString:(NSString*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsArray:(NSArray*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsInt:(int)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithInt:theMessage]];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsNSInteger:(NSInteger)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithInteger:theMessage]];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsNSUInteger:(NSUInteger)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithUnsignedInteger:theMessage]];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsDouble:(double)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithDouble:theMessage]];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsBool:(BOOL)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithBool:theMessage]];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsArrayBuffer:(NSData*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:messageFromArrayBuffer(theMessage)];
}

+ (RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsMultipart:(NSArray*)theMessages
{
    return [[self alloc] initWithStatus:statusOrdinal message:messageFromMultipart(theMessages)];
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
