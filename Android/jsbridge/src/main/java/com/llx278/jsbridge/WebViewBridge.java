package com.llx278.jsbridge;

import android.annotation.SuppressLint;
import android.content.res.AssetManager;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;

import com.llx278.jsbridge.plugin.ActionCallback;
import com.llx278.jsbridge.plugin.ActionPlugin;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 *
 *  js                android
 *  Number           java.lang.Number
 *  Boolean          java.lang.Boolean
 *  String           java.lang.String
 *  // js端通过JSON.stringify转为字符串，再将字符串转为org.json.JSONArray
 *  Array            org.json.JSONArray
 *  // js端通过JSON.stringify转为字符串，再将字符串转为org.json.JSONObject
 *  Object           org.json.JsonObject
 *  // 通过对ArrayBuffer进行base64编码转为字符串，在java端解码转为byte[]
 *  ArrayBuffer      byte[]
 *
 */
public class WebViewBridge {
    public static final boolean DEBUG = BuildConfig.DEBUG;
    public static final String TAG = "WebViewBridge";
    private final ExecutorService exec = Executors.newFixedThreadPool(2);
    private final CommandDelegate delegate;
    private final Map<String,PluginHolder> plugins = new HashMap<>();
    private final ActionPlugin actionPlugin = new ActionPlugin();
    private final String js;
    private final WebView webView;
    @SuppressLint("SetJavaScriptEnabled")
    public WebViewBridge(@NonNull WebView webView) {
        this.webView = webView;
        webView.getSettings().setJavaScriptEnabled(true);
        webView.addJavascriptInterface(this,"RCAndroidJSBridgeHandler");
        String userAgent = webView.getSettings().getUserAgentString();
        webView.getSettings().setUserAgentString("RCAndroid " + userAgent);
        js = readJsCodeFromAsset(webView.getContext().getAssets());
        delegate = new CommandDelegate(webView);
        registerPlugin(actionPlugin);
    }


    private String readJsCodeFromAsset(AssetManager assetManager) {
        int bufSize = 1024;
        byte[] buf = new byte[bufSize];
        int len = 0;
        ByteArrayOutputStream os = null;
        try {
            InputStream is = assetManager.open("js_bridge_es5.js");
            os = new ByteArrayOutputStream();
            while ((len = is.read(buf,0,bufSize)) != -1) {
                os.write(buf,0,len);
            }
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("read js_bridge_es5.js file failed from asset folder",e);
        }
        return os.toString();
    }

    @JavascriptInterface
    public void globalInit() {
        webView.post(
                new Runnable() {
                    @Override
                    public void run() {
                        webView.evaluateJavascript(WebViewBridge.this.js,null);
                    }
                }
        );
    }

    @JavascriptInterface
    public void jsBridgeHandler(String jsonArray) {

        if (TextUtils.isEmpty(jsonArray)) {
            return;
        }

        final InvokeUrlCommand command = InvokeUrlCommand.commandFrom(jsonArray);
        if (command == null) {
            Log.e(TAG,"illegal jsonArray str: " + jsonArray);
            return;
        }

        if (TextUtils.isEmpty(command.getClassName())) {
            Log.e(TAG,"empty class name");
            PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION,
                    "'invalid class name'");
            delegate.sendPluginResult(result,command.getCallbackId());
            return;
        }

        if (TextUtils.isEmpty(command.getMethodName())) {
            Log.e(TAG,"empty method name");
            PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_INVALID_ACTION,
                    "'invalid method name'");
            delegate.sendPluginResult(result,command.getCallbackId());
            return;
        }
        String clsName = command.getClassName();
        if (!plugins.containsKey(clsName)) {
            String errorMsg = "could not found " + clsName;
            Log.e(TAG,errorMsg);
            PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION,
                    errorMsg);
            delegate.sendPluginResult(result,command.getCallbackId());
            return;
        }
        String methodName = command.getMethodName();
        final PluginHolder h = plugins.get(clsName);
        if (h == null) {
            // 永远不会进入到这里，因为前面已经判断了这个plugins一定包含指定的clsName
            return;
        }
        if (!h.jsMethods.containsKey(methodName)) {
            String errorMsg = "could not found " + methodName;
            Log.e(TAG,errorMsg);
            PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_INVALID_ACTION,
                    errorMsg);
            delegate.sendPluginResult(result,command.getCallbackId());
            return;
        }

        final Method method = h.jsMethods.get(methodName);

        exec.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (method != null) {
                        method.invoke(h.plugin,command);
                    }
                } catch (Exception e) {
                    Log.e(TAG,"exec native javascript method throw an exception!",e);
                    PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_NATIVE_METHOD_EXCEPTION,
                            "'exec native javascript method throw an exception!'");
                    delegate.sendPluginResult(result,command.getCallbackId());
                }
            }
        });
    }

    public synchronized void registerAction(String action, ActionCallback callback) {
        actionPlugin.addCallback(action,callback);
    }

    public synchronized void registerPlugin(BasePlugin plugin) {

        Class<? extends BasePlugin> pluginClass = plugin.getClass();
        JavaScriptBridgeClass clsAno = pluginClass.getAnnotation(JavaScriptBridgeClass.class);
        String clsName;
        if (clsAno!= null && !TextUtils.isEmpty(clsAno.className())) {
            clsName = clsAno.className();
        } else {
            clsName = pluginClass.getName();
        }

        if (plugins.containsKey(clsName)) {
            Log.e(TAG,"plugin:"+clsName+" has been registered");
            return;
        }

        Map<String,Method> methodMap = new HashMap<>();
        Method[] methods = pluginClass.getMethods();
        PluginHolder holder = new PluginHolder(plugin,methodMap);
        for (Method method : methods) {
            JavaScriptBridgeMethod anno = method.getAnnotation(JavaScriptBridgeMethod.class);
            if (anno != null) {
                String name;
                if (!TextUtils.isEmpty(anno.methodName())) {
                    name = anno.methodName();
                } else {
                    name = method.getName();
                }

                methodMap.put(name,method);
            }
        }
        plugins.put(clsName,holder);
        plugin.delegate = this.delegate;
    }

    public void dispose() {
        exec.shutdownNow();

        Collection<PluginHolder> pluginValues = plugins.values();
        for (PluginHolder h : pluginValues) {
            h.plugin.dispose();
        }
        delegate.releaseWebView();
    }
}
