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
/**
 * 这个方法由WebViewBridge回调，WebViewBridge需要在合适的地方调用
 * {@link WebViewBridge#dispose()}来通知Plugin webview已经被销毁了
 * 例如在ViewControler中的onViewDidRemoved方法里面调用
 */
-(void)dispose;
@end

NS_ASSUME_NONNULL_END
