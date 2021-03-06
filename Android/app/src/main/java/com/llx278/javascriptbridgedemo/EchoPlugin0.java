package com.llx278.javascriptbridgedemo;

import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;
import com.llx278.jsbridge.PluginResult;
import com.llx278.jsbridge.ThreadMode;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;

import java.util.Random;

@JavaScriptBridgeClass(className = "EchoPlugin0")
public class EchoPlugin0 extends BasePlugin {
    private Random random = new Random(System.currentTimeMillis());
    @Override
    public void dispose() {
    }

    @JavaScriptBridgeMethod(mode = ThreadMode.MAIN)
    public void method0(InvokeUrlCommand command) throws Exception {
        int index = command.getArguments().getInt(0);
        int nap = random.nextInt(2000);
        Thread.sleep(nap);
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, index);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void method1(InvokeUrlCommand command) throws Exception {
        int index = command.getArguments().getInt(0);
        int nap = random.nextInt(2000);
        Thread.sleep(nap);
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, index);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void method2(InvokeUrlCommand command) throws Exception{
        int index = command.getArguments().getInt(0);
        int nap = random.nextInt(2000);
        Thread.sleep(nap);
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, index);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void method3(InvokeUrlCommand command) throws Exception{
        int index = command.getArguments().getInt(0);
        int nap = random.nextInt(2000);
        Thread.sleep(nap);
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, index);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void method4(InvokeUrlCommand command) throws Exception{
        int index = command.getArguments().getInt(0);
        int nap = random.nextInt(2000);
        Thread.sleep(nap);
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, index);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }
}
