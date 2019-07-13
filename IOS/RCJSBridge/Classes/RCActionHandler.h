//
//  RCActionHandler.h
//  Pods-RCJSBridge_Example
//
//  Created by 刘立新 on 2019/3/19.
//

#import "RCPlugin.h"
#import "RCCommandDelegate.h"
#import "RCInvokedUrlCommand.h"
NS_ASSUME_NONNULL_BEGIN

@interface RCActionHandler : RCPlugin
-(void)addCallback:(void(^)(RCInvokedUrlCommand*,RCCommandDelegate*))callback forKey:(NSString*)key;
-(void)globalAction:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
