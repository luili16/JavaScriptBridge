//
//  RCInvokedUrlCommand.m
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCInvokedUrlCommand.h"

@implementation RCInvokedUrlCommand

@synthesize callbackId=_callbackId;
@synthesize className = _className;
@synthesize methodName=_methodName;
@synthesize arguments=_arguments;

+(RCInvokedUrlCommand*)commandFrom:(NSArray *)jsonEntry {
    return [[RCInvokedUrlCommand alloc] initFromJson:jsonEntry];
}

-(id)initFromJson:(NSArray *)jsonEntry {
    
    NSString* callbackId = jsonEntry[0];
    NSString* className = jsonEntry[1];
    NSString* methodName = jsonEntry[2];
    NSArray* arguments;
    if (jsonEntry[3] == nil || jsonEntry[3] == [NSNull null]) {
        arguments = @[];
    } else {
        arguments = jsonEntry[3];
    }

    return [self initWithArguments:callbackId className:className methodName:methodName arguments:arguments];
}

- (id)initWithArguments:(NSString *)callbadkId className:(NSString *)className methodName:(NSString *)methodName arguments:(NSArray *)argumets {
    self = [super init];
    if (self != nil) {
        _callbackId = callbadkId;
        _className = className;
        _methodName = methodName;
        _arguments = argumets;
    }
    [self massageArguments];
    return self;
}

- (void)massageArguments
{
    NSMutableArray* newArgs = nil;
    if (_arguments == nil || [_arguments isKindOfClass:[NSNull class]]) {
        return;
    }
    for (NSUInteger i = 0, count = [_arguments count]; i < count; ++i) {
        id arg = [_arguments objectAtIndex:i];
        if (![arg isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSDictionary* dict = arg;
        NSString* type = [dict objectForKey:@"CDVType"];
        if (!type || ![type isEqualToString:@"ArrayBuffer"]) {
            continue;
        }
        NSString* data = [dict objectForKey:@"data"];
        if (!data) {
            continue;
        }
        if (newArgs == nil) {
            newArgs = [NSMutableArray arrayWithArray:_arguments];
            _arguments = newArgs;
        }
        [newArgs replaceObjectAtIndex:i withObject:[[NSData alloc] initWithBase64EncodedString:data options:0]];
    }
}

-(id)argumentsAtIndex:(NSUInteger)index {
    return [self argumentsAtIndex:index withDefault:nil];
}

-(id)argumentsAtIndex:(NSUInteger)index withDefault:(id)defaultValue {
    return [self argumentsAtIndex:index withDefault:defaultValue andClass:nil];
}

-(id)argumentsAtIndex:(NSUInteger)index withDefault:(id)defaultValue andClass:(Class)aClass {
    if (index >= [_arguments count]) {
        return defaultValue;
    }
    id ret = _arguments[index];
    if (ret == [NSNull null]) {
        ret = defaultValue;
    }
    if ((aClass != nil) && ![ret isKindOfClass:aClass]) {
        ret = defaultValue;
    }
    return ret;
}

@end
