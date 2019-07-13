//
//  TestPlugin4.h
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/22.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <RCJSBridge/RCJSBridge-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestPlugin4 : RCPlugin
-(void)echoString:(RCInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
