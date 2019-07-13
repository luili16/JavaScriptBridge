package com.llx278.jsbridge;

import android.graphics.Bitmap;
import android.util.Log;
import android.webkit.ValueCallback;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class WebViewClientDecorator extends WebViewClient {

    private WebViewClient client;
    private String js;
    public WebViewClientDecorator(WebViewClient client,String js) {
        this.client = client;
        this.js = js;
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        if (this.client != null) {
            this.client.onPageStarted(view,url,favicon);
        }
        Log.d("main","onPageStarted--------");
//        view.evaluateJavascript(this.js, new ValueCallback<String>() {
//            @Override
//            public void onReceiveValue(String value) {
//                Log.d("main","aaavalue:"+value);
//            }
//        });
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        Log.d("main","onPageFinish--------");
        view.evaluateJavascript(this.js, null);
    }
}
