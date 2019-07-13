//
//  RCJSON_private.m
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/18.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCJSON_private.h"
#import <Foundation/NSJSONSerialization.h>

@implementation NSArray (CDVJSONSerializingPrivate)

- (NSString*)rc_JSONString
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSArray JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSDictionary (CDVJSONSerializingPrivate)

- (NSString*)rc_JSONString
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSString (CDVJSONSerializingPrivate)

- (id)rc_JSONObject
{
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    
    if (error != nil) {
        NSLog(@"NSString JSONObject error: %@, Malformed Data: %@", [error localizedDescription], self);
    }
    
    return object;
}

- (id)rc_JSONFragment
{
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    
    if (error != nil) {
        NSLog(@"NSString JSONObject error: %@", [error localizedDescription]);
    }
    
    return object;
}

@end
