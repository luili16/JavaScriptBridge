package com.llx278.javascriptbridgedemo;

import android.util.Base64;
import android.util.Log;

import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.Convert;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;
import com.llx278.jsbridge.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@JavaScriptBridgeClass(className = "TestPlugin")
public class TestPlugin extends BasePlugin {

    public TestPlugin() {
    }

    @JavaScriptBridgeMethod(methodName = "passNumberToNative")
    public void test1(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passNumberToNative method");
        JSONArray args = command.getArguments();
        int arg0 = args.getInt(0);
        double arg1 = args.getDouble(1);
        long arg2 = args.getLong(2);
        long arg3 = args.getLong(3);
        String retVal = arg0 + "-" + arg1 + "-" + arg2 + "-" + arg3;
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,retVal);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passStringToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passStringToNative method!");
        JSONArray args = command.getArguments();
        String arg0 = args.getString(0);
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,arg0);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passBooleanToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passBooleanToNative method!");
        JSONArray args = command.getArguments();
        Boolean arg0 = args.getBoolean(0);
        PluginResult result = PluginResult.resultWithBoolean(CommandStatus.CDVCommandStatus_OK,arg0);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passArrayToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passArrayToNative method");
        JSONArray args = command.getArguments();
        JSONArray array = args.getJSONArray(0);
        String arg0 = array.getString(0);
        int arg1 = array.getInt(1);
        double arg2 = array.getDouble(2);
        String retVal = arg0 + "-" + arg1 + "-" + arg2;
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,retVal);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passObjectToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passObjectToNative method");
        JSONArray args = command.getArguments();
        JSONObject obj = args.getJSONObject(0);
        String user = obj.getString("user");
        Log.d("main","user is : " + user);
        String info = obj.getString("info");
        Log.d("main","info is : " + info);
        int account = obj.getInt("account");
        Log.d("main","account is : " + account);
        JSONObject map = obj.getJSONObject("map");
        Log.d("main","map is : " + map.toString());
        JSONArray array = obj.getJSONArray("array");
        Log.d("main","array is : " + array.toString());
        PluginResult result = PluginResult.resultWithJsonObject(CommandStatus.CDVCommandStatus_OK,obj);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passNullToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passNullToNative method");
        JSONArray args = command.getArguments();
        String arg0 = args.getString(0);
        Log.d("main","arg0 : " + arg0);
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,arg0);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passEmptyToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passEmptyToNative method");
        Log.d("main","arg size:" + command.getArguments().length());
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"success");
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void passArrayBufToNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call passArrayBufToNative method");
        String base64 = command.getArguments().getString(0);
        byte[] data = Convert.toBytes(command.getArguments().getJSONObject(1));
        String js64 = Base64.encodeToString(data,Base64.NO_WRAP);
        Log.d("main","base64Fromjs :    " + base64);
        Log.d("main","base64FromNative: " + js64);
        boolean eq = base64.equals(js64);
        PluginResult result = PluginResult.resultWithBoolean(CommandStatus.CDVCommandStatus_OK,eq);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @Override
    public void dispose() {
        Log.d("main","call dispose");
    }
}
