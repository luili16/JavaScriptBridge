package com.llx278.javascriptbridgedemo;

import android.util.Log;

import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;
import com.llx278.jsbridge.PluginResult;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;

@JavaScriptBridgeClass(className = "CallbackPlugin")
public class CallbackPlugin extends BasePlugin {


    @JavaScriptBridgeMethod
    public void callbackNumberFromNative(InvokeUrlCommand command) {
        Log.d("main","call callbackNumberFromNative");
        PluginResult result = PluginResult.resultWithNumber(CommandStatus.CDVCommandStatus_OK, 3.141d);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void callbackStringFromNative(InvokeUrlCommand command) {
        Log.d("main","call callbackStringFromNative");
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"hello world!!");
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void callbackArrayFromNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call callbackArrayFromNative");
        JSONArray array = new JSONArray();
        array.put(123);
        array.put("hello");
        JSONObject object = new JSONObject();
        object.put("a","dfdfd");
        object.put("b",13);
        array.put(object);
        PluginResult result = PluginResult.resultWithJsonArray(CommandStatus.CDVCommandStatus_OK,array);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void callbackObjFromNative(InvokeUrlCommand command) throws JSONException {
        Log.d("main","call callbackObjFromNative");
        JSONObject object = new JSONObject();
        object.put("a","hello");
        object.put("b","world");
        PluginResult result = PluginResult.resultWithJsonObject(CommandStatus.CDVCommandStatus_OK,object);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void callbackArrayBufferFromNative(InvokeUrlCommand command) throws Exception {
        Log.d("main","call callbackArrayBufferFromNative");

        String str  = "hello android world";
        byte[] bytes = str.getBytes(StandardCharsets.UTF_8);
        // 计算md5加密
        String md5 = md5Decode(str);
        Log.d("main","md5 : " + md5);
        PluginResult result = PluginResult.resultWithArrayBuffer(CommandStatus.CDVCommandStatus_OK,bytes);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    @JavaScriptBridgeMethod
    public void callbackVoidFromNative(InvokeUrlCommand command) throws Exception {
        Log.d("main","call callbackVoidFromNative");
        PluginResult result = PluginResult.resultWithVoid(CommandStatus.CDVCommandStatus_OK);
        getDelegate().sendPluginResult(result,command.getCallbackId());
    }

    private String md5Decode(String content) {
        byte[] hash;
        try {
            hash = MessageDigest.getInstance("MD5").digest(content.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("NoSuchAlgorithmException",e);
        }
        //对生成的16字节数组进行补零操作
        StringBuilder hex = new StringBuilder(hash.length * 2);
        for (byte b : hash) {
            if ((b & 0xFF) < 0x10){
                hex.append("0");
            }
            hex.append(Integer.toHexString(b & 0xFF));
        }
        return hex.toString();
    }

    @JavaScriptBridgeMethod
    public void keepCallbackFromString(InvokeUrlCommand command) throws Exception {
        List<String> lists = Arrays.asList("hello","world","from","java","script");
        for (String s : lists) {
            PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,s);
            getDelegate().sendPluginResult(result,command.getCallbackId(),true);
            Thread.sleep(3000);
        }
        PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"done");
        getDelegate().sendPluginResult(result,command.getCallbackId(),false);
        result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"over");
        getDelegate().sendPluginResult(result,command.getCallbackId(),false);
    }

    @Override
    public void dispose() {
    }
}
