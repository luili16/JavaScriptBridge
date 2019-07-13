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

@interface RCPluginResult : NSObject {
    @public
    NSNumber* status;
    @public
    id message;
}
@property(nonatomic,strong,readonly) NSNumber* status;
@property(nonatomic,strong,readonly) id message;

-(RCPluginResult*)init;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsString:(NSString*)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsArray:(NSArray*)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsInt:(int)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsNSInteger:(NSInteger)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsNSUInteger:(NSUInteger)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsDouble:(double)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsBool:(BOOL)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsArrayBuffer:(NSData*)theMessage;
+(RCPluginResult*)resultWithStatus:(RCCommandStatus)statusOrdinal messageAsMultipart:(NSArray*)theMessages;
-(NSString*)argumentsAsJson;
@end

NS_ASSUME_NONNULL_END
