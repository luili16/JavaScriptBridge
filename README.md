# JavaScriptBridge
A JavaScript Bridge for ios(WKWebView) and Android(WebView)

## 如何使用

Js端

​	js端在使用前需要调用一次初始化代码

```javascript
// check if we are in android os
// 目前一直没有找到一个稳定的无侵入的js注入点，所以
// 在android设备上需要执行一段全局初始化的代码
if (isInAndroid) {
  	// init only once
    window.RCAndroidJSBridgeHandler.globalInit()
}
// now we can call
window.RCJSBridge.exec(
	function success(response) { // 0
    let data = response.data;
    // 对从native返回的数据做处理
  },
  function error(response) { // 1
    // stauts 错误的状态码
    // 没有返回结果
    // window.RCJSBridge.rcCommandStatus.CDVCommandStatus_NO_RESULT 
    // 没有在native找到对应的类名
    // window.RCJSBridge.rcCommandStatus.CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION
    // 没有在native找到对应的方法名
    // window.RCJSBridge.rcCommandStatus.CDVCommandStatus_INVALID_ACTION
    // 执行本地方法出现异常
    // window.RCJSBridge.rcCommandStatus.CDVCommandStatus_NATIVE_METHOD_EXCEPTION
    // 其他错误
    // window.RCJSBridge.rcCommandStatus.CDVCommandStatus_ERROR
    let status = response.status;
 		// 出错的详细信息
    let data = response.data;
    // 错误处理逻辑...
  },
  "className", // 2
  "methodName", // 3
  ["args0","args1"] // 4
);
// 0 -> 成功, 返回调用结果
// 1 -> 失败, 返回错误信息
// 2 -> 调用的类名
// 3 -> 调用的方法名
// 4 -> 方法的参数，用一个数组描述，数组的每个位置代表一个参数
```



Android端

​	所有的Plugin都需要继承com.llx278.jsbridge.BasePlugin

```java
import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.Convert;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;
import com.llx278.jsbridge.PluginResult;

// 所有的类名都需要添加以下注解，
// className如果不设置的话就默认以被注解的类(如TestPlugin)的全类名  (com.llx278.javascriptbridgedemo.TestPlugin)作为className
@JavaScriptBridgeClass(className = "TestPlugin")
public class TestPlugin extends BasePlugin {
  
  // 所有的方法名都需要添加以下注解
  // methodName如果不设置的话就默认以当前的方法名(如test1)作为methodName
  @JavaScriptBridgeMethod(methodName = "passNumberToNative")
 	public void test1(InvokeUrlCommand command) {
    // InvokeUrlCommand封装了js端传来的参数以JSONArray描述
    Log.d("main","call passNumberToNative method");
    JSONArray args = command.getArguments();
		int arg0 = args.getInt(0); // js端传来第一个参数
    double arg1 = args.getDouble(1); // 第二个
    long arg2 = args.getLong(2); // 第三个
    long arg3 = args.getLong(3); // 第四个
    String retVal = arg0 + "-" + arg1 + "-" + arg2 + "-" + arg3;
    // 方法执行的结果需要封装为PluginResult
    PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,retVal);
    // 通过BasePlugin封装的getDelegate()方法将执行结果发送给js端 
    getDelegate().sendPluginResult(result,command.getCallbackId());
   	// done
  }
}

// js端与android端的数据类型
//       js                         android
//     Number                      java.lang.Number // number就对应了int long double 根据需要自己转
//     Boolean                     java.lang.Boolean
//     Array                       org.json.JSONArray
//     Object                      org.json.JSONObject
//     ArrayBuffer                 byte[]

```



IOS端

 	所有的Plugin都需要继承RCPlugin.m

RCTestPlugin.h

```objective-c
#import <RCJSBridge/RCPlugin.h>
#import <RCInvokedUrlCommand.h>
NS_ASSUME_NONNULL_BEGIN
@interface RCTestPlugin : RCPlugin
  -(void)passNumberToNative:(RCInvokedUrlCommand*)command;
// 其他方法...
@end
NS_ASSUME_NONNULL_END
```

RCTestPlugin.m

```objective-c

#import "RCTestPlugin.h"
#import <RCPluginResult.h>
@implementation RCTestPlugin
  
  - (void)passNumberToNative:(RCInvokedUrlCommand *)command {
    NSLog(@"call passNumberToNative method");
  // RCInvokedUrlCommand封装了js端传来的参数
    NSArray* args = command.arguments;
    NSNumber* arg0Int = args[0]; // js端传来的第一个参数
    NSNumber* arg1Double = args[1]; // 第二个
    NSNumber* arg2Long = args[2]; // 第三个
    NSNumber* arg3Long = args[3]; // 第四个
    NSString* retVal = [NSString stringWithFormat:@"%d-%f-%ld-%ld",[arg0Int intValue],[arg1Double doubleValue],[arg2Long longValue],[arg3Long longValue]];
  // 方法执行结果封装为RCPluginResult
    RCPluginResult* result = [RCPluginResult resultWithString:retVal andStatus:CDVCommandStatus_OK];
  // 通过BasePlugin封装的commandDelegate将执行的结果发送给js端
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
  // done
}
//   js端与ios端的数据类型
//       js               ios
//      Number           Number
//      Boolean          BOOL
//      String           NSString
//      Array            NSArray
//      Object           NSDictionary
//     ArrayBuffer       NSData
@end

```



js端调用

```javascript
window.RCJSBridge.exec(
  function success(response) {
    console.log("success  返回值是 " + response.data);
		alert("success  返回值是 " + response.data);
  },
  function error(response) {
    console.log("error : " + response.data);
		alert("error : " + response.data);
  },
  "TestPlugin",
  "passNumberToNative",
  [123,3.1415926,Number.MAX_SAFE_INTEGER,Number.MIN_SAFE_INTEGER]
);
```



详细的测试用例请看demo