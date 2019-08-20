package com.llx278.jsbridge.plugin;

import android.util.Log;

import androidx.annotation.NonNull;

import com.llx278.jsbridge.WebViewBridge;

import org.json.JSONArray;
import org.json.JSONException;

public class InvokeUrlCommand {
    private @NonNull
    final String callbackId;
    private @NonNull final String className;
    private @NonNull final String methodName;
    private @NonNull final JSONArray arguments;

    public static InvokeUrlCommand commandFrom(String jsonArrayStr) {
        try {
            JSONArray jsonArray = new JSONArray(jsonArrayStr);
            String callbackId = jsonArray.getString(0);
            String className = jsonArray.getString(1);
            String methodName = jsonArray.getString(2);
            JSONArray arguments = jsonArray.getJSONArray(3);
            return new InvokeUrlCommand(callbackId,className,methodName,arguments);
        } catch (JSONException e) {
            Log.e(WebViewBridge.TAG,"parse Json Array failed, json array str is " + jsonArrayStr ,e);
            return null;
        }
    }

    /**
     * 代表一次js端的调用
     * @param callbackId 标志一个唯一的js调用
     * @param className 类名
     * @param methodName 方法名
     * @param arguments 参数
     */
    InvokeUrlCommand(@NonNull String callbackId, @NonNull String className, @NonNull String methodName, @NonNull JSONArray arguments) {
        this.callbackId = callbackId;
        this.className = className;
        this.methodName = methodName;
        this.arguments = arguments;
    }

    public @NonNull String getCallbackId() {
        return callbackId;
    }

    public @NonNull String getClassName() {
        return className;
    }

    public @NonNull String getMethodName() {
        return methodName;
    }

    public @NonNull JSONArray getArguments() {
        return arguments;
    }
}
