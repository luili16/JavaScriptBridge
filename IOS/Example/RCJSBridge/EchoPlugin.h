//
//  EchoPlugin.h
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/18.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <RCJSBridge/RCJSBridge-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *   在32位系统中
 int 占4个字节
 long 占4个字节
 NSInteger 是int的别名，占4个字节
 long long 占8个字节
 int32_t 是int的别名，占4个字节
 int64_t 是long long的别名，占8个字节
 
 在64位系统中
 int 占4个字节
 long 占8个字节
 NSInteger 是long的别名，占8个字节
 long long 占8个字节
 int32_t 是int的别名，占4个字节
 int64_t 是long long的别名，占8个字节
 
 由于long和NSInteger的字节数变了，所以在兼容的时候可能会导致溢出
 
 4字节的整数变量，它的范围是
 -2147483648 ~ 2147483647
 如果不带符号，它的范围是
 0 ~ 4294967295
 
 8字节的整数变量，它的范围是
 -9223372036854775808 ~ 9223372036854775807
 如果不带符号，它的范围是    9007199254740991
 0 ~ 18446744073709551615
 
 ios里NSInteger的文档:
 iOS, macOS, tvOS
 typedef long NSInteger;
 watchOS
 typedef int NSInteger;
 NSInteger本质上是long型
 
 iOS, macOS, tvOS
 typedef unsigned long NSUInteger;
 watchOS
 typedef unsigned int NSUInteger;
 NSInteger本质上 unsigned long 型
 
 
 在js端数字统一表示为Number，因此对于number来说
 Number.MAX_SAFE_INTEGER
 由 https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
 可知: MAX_SAFE_INTEGER 是一个值为9007199254740991的常量，对于ios中int来讲是安全的,但却远远的小于long所表示的范围
 Number.MIN_SAFE_INTEGER
 由 https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER
 可知:MIN_SAFE_INTEGER是一个值为-9007199254740991的常亮，对于ios中的int来讲也是安全的，但却远远大于long所表示的范围
 因此在ios设备上将NSInteger转为Number会有溢出的可能
 **/

@interface EchoPlugin : RCPlugin

-(EchoPlugin*)initWithViewController:(UIViewController*)controller;

-(void)echoString:(RCInvokedUrlCommand*)command;
-(void)echoArray:(RCInvokedUrlCommand*)command;
-(void)echoInt:(RCInvokedUrlCommand*)command;
-(void)echoMaxInt:(RCInvokedUrlCommand*)command;
-(void)echoMinInt:(RCInvokedUrlCommand*)command;
-(void)echoInteger:(RCInvokedUrlCommand*)command;
-(void)echoMaxInteger:(RCInvokedUrlCommand*)command;
-(void)echoMinInteger:(RCInvokedUrlCommand*)command;
-(void)echoUInteger:(RCInvokedUrlCommand*)command;
-(void)echoMaxUInteger:(RCInvokedUrlCommand*)command;
-(void)echoMinUInteger:(RCInvokedUrlCommand*)command;
-(void)echoDouble:(RCInvokedUrlCommand*)command;
-(void)echoBool:(RCInvokedUrlCommand*)command;
-(void)echoDictionary:(RCInvokedUrlCommand*)command;
-(void)echoArrayBuffer:(RCInvokedUrlCommand*)command;
-(void)diffArrayBuffer:(RCInvokedUrlCommand*)command;
-(void)echoMultipart:(RCInvokedUrlCommand*)command;
-(void)openNextPage:(RCInvokedUrlCommand*)command;
-(void)echoKeepCallback:(RCInvokedUrlCommand*)command;
-(void)echoBack:(RCInvokedUrlCommand*)command;
-(void)echoCallErrorCallback:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
