//
//  RCActionHandler.m
//  Pods-RCJSBridge_Example
//
//  Created by 刘立新 on 2019/3/19.
//

#import "RCActionHandler.h"

@interface RCActionHandler() {
    @private
    NSMutableDictionary<NSString*,void (^)(RCInvokedUrlCommand * _Nonnull, RCCommandDelegate * _Nonnull)>* _callbackDictionary;
}
@end

@implementation RCActionHandler

- (void)pluginInitialize {
    _callbackDictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
}

- (void)addCallback:(void (^)(RCInvokedUrlCommand * _Nonnull, RCCommandDelegate * _Nonnull))callback forKey:(NSString *)key {
    [_callbackDictionary setObject:callback forKey:key];
}

- (void)globalAction:(RCInvokedUrlCommand *)command {
    // 最后一个参数指明了对应的动作
    NSString* action = [command.arguments lastObject];
    void (^callback)(RCInvokedUrlCommand * _Nonnull, RCCommandDelegate * _Nonnull) = _callbackDictionary[action];
    if (callback != nil) {
        NSMutableArray* nextArgs = [[NSMutableArray alloc]initWithArray:command.arguments];
        [nextArgs removeLastObject];
        RCInvokedUrlCommand* nextCommand = [[RCInvokedUrlCommand alloc]initWithArguments:command.callbackId className:command.className methodName:command.methodName arguments:nextArgs];
        callback(nextCommand,self.commandDelegate);
    }
}
@end
