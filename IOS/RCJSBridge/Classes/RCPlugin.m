//
//  RCPlugin.m
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCPlugin.h"
#import "RCInvokedUrlCommand.h"

@interface RCPlugin() {
@private
    RCCommandDelegate* _commandDelegate;
}

@end

@implementation RCPlugin
@synthesize commandDelegate = _commandDelegate;

- (void)dispose {
}
@end
