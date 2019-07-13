package com.llx278.jsbridge;

import android.app.Activity;
import android.util.Log;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import java.util.Locale;

public class CommandDelegate {
    private WebView webView;
    CommandDelegate(WebView webView) {
        this.webView = webView;
    }

    public void sendPluginResult(PluginResult result, String callbackId) {
        sendPluginResult(result,callbackId,false);
    }

    public void sendPluginResult(PluginResult result, String callbackId, boolean keepCallback) {
        int status = result.getStatus().getStatus();
        String value = result.argumentsAsJson();

        final String js = String.format(Locale.CHINA,"window.RCJSBridge.nativeCallback('%s',%d,%b,%s);",callbackId,status,keepCallback,value);
        Log.d("main","jsStr : " + js);
        if (webView != null) {
            webView.post(new Runnable() {
                @Override
                public void run() {
                    if (webView != null) {
                        webView.evaluateJavascript(js, null);
                    }
                }
            });
        }
    }

    void releaseWebView() {
        webView = null;
    }
}
