package com.llx278.jsbridge;

public abstract class BasePlugin {
    CommandDelegate delegate;

    /**
     * 这个方法由WebViewBridge回调，WebViewBridge需要在合适的地方调用
     * {@link WebViewBridge#dispose()}来通知Plugin webview已经被销毁了
     * 例如在Activity或fragment的onDestroy()方法里面调用
     */
    public abstract void dispose();

    public CommandDelegate getDelegate() {
        return this.delegate;
    }
}
