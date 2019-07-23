package com.llx278.jsbridge.plugin;

import com.llx278.jsbridge.BasePlugin;
import com.llx278.jsbridge.JavaScriptBridgeClass;
import com.llx278.jsbridge.JavaScriptBridgeMethod;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.HashMap;
import java.util.Map;

@JavaScriptBridgeClass(className = "RCActionHandler#12306")
public class ActionPlugin extends BasePlugin {

    private Map<String, ActionCallback> callbackMap = new HashMap<>();

    public void addCallback(String action,ActionCallback callback) {
        callbackMap.put(action,callback);
    }

    @JavaScriptBridgeMethod
    public void globalAction(InvokeUrlCommand command) throws JSONException {
        // 最后一个参数指明了动作
        JSONArray args = command.getArguments();
        String action = args.getString(args.length() - 1);
        ActionCallback callback = callbackMap.get(action);
        if (callback != null) {
            args.remove(args.length() - 1);
            InvokeUrlCommand nextCommand = new InvokeUrlCommand(command.getCallbackId(),
                    command.getClassName(),
                    command.getMethodName(),
                    args);
            callback.onExec(nextCommand,getDelegate());
        }
    }

    @Override
    public void dispose() {
        callbackMap.clear();
    }
}
