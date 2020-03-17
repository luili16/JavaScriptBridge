package com.llx278.jsbridge;

import android.webkit.ValueCallback;

public interface IJsExecutor {
    void evaluateJavascript(String js, ValueCallback<String> callback);
}
