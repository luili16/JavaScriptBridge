//
//  RCInvokedUrlCommand.h
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCInvokedUrlCommand : NSObject
@property(nonatomic,readonly,strong) NSString* callbackId;
@property(nonatomic,readonly,strong) NSString* className;
@property(nonatomic,readonly,strong) NSString* methodName;
// 数组里的类型只可能是:  NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull
// 参考WKScriptMessage.body的文档描述
@property(nonatomic,readonly,strong) NSArray* arguments;

+(RCInvokedUrlCommand*)commandFrom:(NSArray*)jsonEntry;

-(id)initWithArguments:(NSString*)callbadkId className:(NSString*)className methodName:(NSString*)methodName arguments:(NSArray*)argumets;
-(id)initFromJson:(NSArray*)jsonEntry;
// Returns the argument at the given index.
// If index >= the number of arguments, returns nil.
// If the argument at the given index is NSNull, returns nil.
-(id)argumentsAtIndex:(NSUInteger)index;
// Same as above, but returns defaultValue instead of nil.
-(id)argumentsAtIndex:(NSUInteger)index withDefault:(nullable id)defaultValue;
// Same as above, but returns defaultValue instead of nil, and if the argument is not of the expected class, returns defaultValue
-(id)argumentsAtIndex:(NSUInteger)index withDefault:(nullable id)defaultValue andClass:(nullable Class)aClass;
@end

NS_ASSUME_NONNULL_END
