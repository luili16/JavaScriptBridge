package com.llx278.jsbridge;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;

public class InvokeUrlCommand {
    private String callbackId;
    private String className;
    private String methodName;
    private JSONArray arguments;

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

    private InvokeUrlCommand(String callbackId,String className,String methodName,JSONArray arguments) {
        this.callbackId = callbackId;
        this.className = className;
        this.methodName = methodName;
        this.arguments = arguments;
    }

    public String getCallbackId() {
        return callbackId;
    }

    public String getClassName() {
        return className;
    }

    public String getMethodName() {
        return methodName;
    }

    public JSONArray getArguments() {
        return arguments;
    }
}
