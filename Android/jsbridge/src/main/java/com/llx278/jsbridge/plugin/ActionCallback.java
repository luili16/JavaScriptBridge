package com.llx278.jsbridge.plugin;

import com.llx278.jsbridge.CommandDelegate;

import org.json.JSONException;

/**
 * js端回调接口
 */
public interface ActionCallback {

    /**
     * js端回调此方法
     * @param command 向js端发送执行结果
     */
    public void onExec(InvokeUrlCommand command, CommandDelegate delegate) throws JSONException;
}
