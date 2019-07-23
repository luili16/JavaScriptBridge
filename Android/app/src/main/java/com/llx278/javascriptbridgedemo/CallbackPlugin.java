package com.llx278.javascriptbridgedemo;

import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;

@JavaScriptBridgeClass(className = "CallbackPlugin")
public class CallbackPlugin extends BasePlugin {


    @JavaScriptBridgeMethod
    public void callbackNumberFromNative() {

    }

    @JavaScriptBridgeMethod
    public void callbackStringFromNative() {

    }

    @JavaScriptBridgeMethod
    public void callbackArrayFromNative() {

    }

    @JavaScriptBridgeMethod
    public void callbackObjFromNative() {

    }


    @Override
    public void dispose() {

    }
}
