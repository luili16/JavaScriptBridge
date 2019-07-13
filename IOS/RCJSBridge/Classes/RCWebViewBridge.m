//
//  RCWebViewEngine.m
//  RCJSBridgeDemo
//
//  Created by 刘立新 on 2019/2/15.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import "RCWebViewBridge.h"
#import <WebKit/WebKit.h>
#import "RCPlugin.h"
#import "RCCommandDelegate.h"
#import "RCInvokedUrlCommand.h"
#import <Foundation/Foundation.h>
#import "RCJSON_private.h"
#import "RCActionHandler.h"

@interface RCWebViewBridge()<WKScriptMessageHandler> {
    @private
    WKWebView* _wkWebView;
    @private
    NSMutableDictionary<NSString*,RCPlugin*>* _pluginsObject;
    @private
    RCCommandDelegate* _commandDelegate;
    @private
    RCActionHandler* _handler;
    @private
    NSOperationQueue* _commandQueue;
}
@end
@implementation RCWebViewBridge

- (RCWebViewBridge *)initWithWkWebView:(WKWebView *)wkWebView {
    self = [super init];
    if (self) {
        _wkWebView = wkWebView;
        _pluginsObject = [[NSMutableDictionary alloc]initWithCapacity:10];
        // inject rc_js_bridge.js
        NSBundle* jsBridgeFrameWork = [NSBundle bundleForClass:self.class];
        NSURL* rCJSBridgeBundleUrl = [jsBridgeFrameWork URLForResource:@"RCJSBridge" withExtension:@"bundle"];
        NSBundle* rCJSBridgeBundle = [NSBundle bundleWithURL:rCJSBridgeBundleUrl];
        NSString* pathForJavascriptStr = [rCJSBridgeBundle pathForResource:@"rc_js_bridge" ofType:@"js"];
        NSString* jsStr = [NSString stringWithContentsOfFile:pathForJavascriptStr encoding:NSUTF8StringEncoding error:nil];
        WKUserScript* script = [[WKUserScript alloc]initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [wkWebView.configuration.userContentController addUserScript:script];
        [wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"RCJSBridgeHandler"];
        
        _commandDelegate = [[RCCommandDelegate alloc]initWithWebView:_wkWebView];
        _commandQueue = [[NSOperationQueue alloc]init];
        //_commandQueue.name = @"RCJSBridgeDispatchEventQueue";
        // 注册RCActionHandler
        _handler= [[RCActionHandler alloc]init];
        [self registerPlugin:_handler withClassName:@"RCActionHandler#12306"];
    }
    return self;
}

-(void)registerPluinInConfigFile:(NSString*)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSData* data = [fileManager contentsAtPath:path];
    NSArray* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (int i = 0; i < dic.count; i++) {
        NSDictionary* obj = dic[i];
        NSDictionary* service = obj[@"service"];
        NSString* className = service[@"className-ios"];
        NSLog(@"className-ios : %@",className);
        RCPlugin* plugin = [[NSClassFromString(className) alloc] init];
        [self registerPlugin:plugin withClassName:className];
    }
}

- (void)registerPlugin:(RCPlugin *)plugin withClassName:(NSString *)className {
    if (className == nil) {
        return;
    }
    if ([_pluginsObject objectForKey:className] != nil) {
        NSLog(@"WARNING: className:%@ has been registered!",className);
    }
    plugin.commandDelegate = _commandDelegate;
    [plugin pluginInitialize];
    [_pluginsObject setObject:plugin forKey:className];
}

-(void)registerPlugin:(RCPlugin *)plugin {
    NSString* className = NSStringFromClass(plugin.class);
    [self registerPlugin:plugin withClassName:className];
}

-(void)registerPlugins:(NSArray<RCPlugin *> *)plugins {
    for (int i = 0; i < plugins.count; i++) {
        RCPlugin* plugin = plugins[i];
        [self registerPlugin:plugin];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSArray* jsonEntry = message.body;
    if (jsonEntry == nil) {
        return;
    }
    RCInvokedUrlCommand* command = [RCInvokedUrlCommand commandFrom:jsonEntry];
    //NSLog(@"RCInvokedUrlCommand:callbackId=%@",command.callbackId);
    //NSLog(@"RCInvokedUrlCommand:className=%@",command.className);
    //NSLog(@"RCInvokedUrlCommand:methodName=%@",command.methodName);
    //NSLog(@"RCInvokedUrlCommand:arguments=%@",command.arguments);
    [self exec:command];
}

- (void)registerAction:(NSString *)action callback:(void (^)(RCInvokedUrlCommand * _Nonnull, RCCommandDelegate * _Nonnull))callback {
    [_handler addCallback:callback forKey:action];
}

-(void)exec:(RCInvokedUrlCommand*)command {
    
    if (command.className == nil || [command.className isKindOfClass:[NSNull class]]) {
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION messageAsString:@"service name is null"];
        [_commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    if (command.methodName == nil || [command.methodName isKindOfClass:[NSNull class]]) {
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsString:@"actioin name is null"];
        [_commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    RCPlugin* plugin = _pluginsObject[command.className];
    if (plugin == nil || !([plugin isKindOfClass:[RCPlugin class]])) {
        NSString* err =[NSString stringWithFormat:@"ERROR: Plugin '%@' not found, or is not a RCPlugin. Check your plugin mapping in plugin.json. current plugins key: %@",command.className,_pluginsObject];
        NSLog(@"%@", err);
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION messageAsString:err];
        [_commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    NSString* realMethodName = [command.methodName stringByAppendingString:@":"];
    NSLog(@"exec method: %@ from class: %@",realMethodName,command.className);
    SEL normalSelector = NSSelectorFromString(realMethodName);
    if (![plugin respondsToSelector:normalSelector]) {
        NSString* err = [NSString stringWithFormat:@"ERROR: Plugin '%@' could not response to method name '%@'",command.className,command.methodName];
        NSLog(@"%@",err);
        RCPluginResult* result = [RCPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsString:err];
        [_commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    NSInvocationOperation* operation = [[NSInvocationOperation alloc]initWithTarget:plugin selector:normalSelector object:command];
    [_commandQueue addOperation:operation];
}

-(void)dispose {
    NSLog(@"RCWebViewBridge call dispose");
    _wkWebView = nil;
    [_commandDelegate dispose];
    // 清除所有尚未完成的任务
    [_commandQueue cancelAllOperations];
    for (NSString* key in _pluginsObject) {
        RCPlugin* plugin = _pluginsObject[key];
        [plugin dispose];
    }
}

@end
