package com.llx278.jsbridge;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.smtt.sdk.WebView;

import java.util.Locale;

public class CommandDelegate {
    private WebView webView;
    private Handler mainHandler;
    CommandDelegate(@NonNull WebView webView, Handler mainHandler) {
        this.webView = webView;
        this.mainHandler = mainHandler;
    }

    public void sendPluginResult(@NonNull PluginResult result, @NonNull String callbackId) {
        sendPluginResult(result,callbackId,false);
    }

    private boolean isMainThread() {
        Looper looper = Looper.getMainLooper();
        return looper == Looper.myLooper();
    }

    /**
     *
     * @param result js调用的结果
     * @param callbackId js端维护的callbackId
     * @param keepCallback true 此次调用结束了以后，js端不会删掉这个callbackId，客户端可以连续用callbackId来发送消息，
     *                     直到将keepCallback设置为false
     *                     false 此次调用结束了以后，js端会删掉这个callbackId
     */
    public void sendPluginResult(PluginResult result, String callbackId, boolean keepCallback) {
        int status = result.getStatus().getStatus();
        String value = result.argumentsAsJson();

        final String js = String.format(Locale.CHINA,"window.RCJSBridge.nativeCallback('%s',%d,%b,%s);",callbackId,status,keepCallback,value);
        if (WebViewBridge.DEBUG) {
            Log.d("main","jsStr : " + js);
        }
        if (webView != null) {
            if (isMainThread()) {
                webView.evaluateJavascript(js, null);
            } else {
                mainHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (webView != null) {
                            webView.evaluateJavascript(js, null);
                        }
                    }
                });
            }
        }
    }

    void releaseWebView() {
        webView = null;
    }
}
