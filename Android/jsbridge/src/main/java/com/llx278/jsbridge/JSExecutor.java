package com.llx278.jsbridge;

import android.util.Log;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import androidx.annotation.NonNull;

public class JSExecutor implements IJsExecutor {

    private WebView systemWebView;
    private com.tencent.smtt.sdk.WebView x5WebView;

    JSExecutor(@NonNull WebView webView) {
        this.systemWebView = webView;
    }

    JSExecutor(@NonNull com.tencent.smtt.sdk.WebView webView) {
        this.x5WebView = webView;
    }


    @Override
    public void evaluateJavascript(String js, final ValueCallback<String> callback) {
        if (systemWebView != null) {
            systemWebView.evaluateJavascript(js,callback);
        } else if (x5WebView != null) {
            x5WebView.evaluateJavascript(js, new com.tencent.smtt.sdk.ValueCallback<String>() {
                @Override
                public void onReceiveValue(String s) {
                    if (callback != null) {
                        callback.onReceiveValue(s);
                    }
                }
            });
        } else {
            Log.e(WebViewBridge.TAG,"webView is null");
        }
    }
}
