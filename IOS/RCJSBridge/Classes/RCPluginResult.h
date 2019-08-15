//
//  RCPluginResult.h
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CDVCommandStatus_NO_RESULT = 0,
    CDVCommandStatus_OK,
    CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION,
    CDVCommandStatus_INVALID_ACTION,
    CDVCommandStatus_NATIVE_METHOD_EXCEPTION,
    CDVCommandStatus_ERROR
} RCCommandStatus;

@interface RCPluginResult : NSObject
@property(nonatomic,strong,readonly) NSNumber* status;
@property(nonatomic,strong,readonly) id message;

+(RCPluginResult*)resultWithVoid:(RCCommandStatus)status;
+(RCPluginResult*)resultWithString:(NSString*)message andStatus:(RCCommandStatus)status;
+(RCPluginResult*)resultWithNumber:(NSNumber*)message andStatus:(RCCommandStatus)status;
+(RCPluginResult*)resultWithBoolean:(BOOL)message andStatus:(RCCommandStatus)status;
+(RCPluginResult*)resultWithArray:(NSArray*)message andStatus:(RCCommandStatus)status;
+(RCPluginResult*)resultWithDictionary:(NSDictionary*)message andStatus:(RCCommandStatus)status;
+(RCPluginResult*)resultWithArrayBuffer:(NSData*)message andStatus:(RCCommandStatus)status;

-(NSString*)argumentsAsJson;
@end

NS_ASSUME_NONNULL_END
