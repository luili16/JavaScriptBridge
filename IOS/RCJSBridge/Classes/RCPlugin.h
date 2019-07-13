//
//  RCPlugin.h
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCCommandDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCPlugin : NSObject {
}
@property RCCommandDelegate* commandDelegate;
//-(RCPlugin*)initWithWebView:(WKWebView*)wkWebView viewController:(UIViewController*)viewController commandDelegate:(RCCommandDelegate*)commandDelegate;
- (void)pluginInitialize;
-(void)dispose;
@end

NS_ASSUME_NONNULL_END
