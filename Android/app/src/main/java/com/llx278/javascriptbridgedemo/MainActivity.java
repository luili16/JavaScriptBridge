package com.llx278.javascriptbridgedemo;

import android.annotation.SuppressLint;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.llx278.jsbridge.CommandDelegate;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.PluginResult;
import com.llx278.jsbridge.WebViewBridge;
import com.llx278.jsbridge.plugin.ActionCallback;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;
import com.tencent.smtt.sdk.WebChromeClient;
import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import org.json.JSONArray;
import org.json.JSONException;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private android.webkit.WebView systemWebView;
    private WebViewBridge bridge;
    private WebViewBridge systemBridge;


    private void initSystemWebView() {
        systemWebView = findViewById(R.id.systemwebview);
        systemWebView.getSettings().setJavaScriptEnabled(true);
        systemWebView.setWebChromeClient(new android.webkit.WebChromeClient());
        systemWebView.setWebViewClient(new android.webkit.WebViewClient());
        WebView.setWebContentsDebuggingEnabled(true);
        systemBridge = new WebViewBridge(systemWebView);
        TestPlugin plugin = new TestPlugin();
        CallbackPlugin callbackPlugin = new CallbackPlugin();
        systemBridge.registerPlugin(plugin);
        systemBridge.registerPlugin(callbackPlugin);
        systemBridge.registerPlugin(new EchoPlugin0());
        systemBridge.registerPlugin(new EchoPlugin1());
        systemBridge.registerAction("customAction1", new ActionCallback() {
            @Override
            public void onExec(InvokeUrlCommand command, CommandDelegate delegate) throws JSONException {
                Log.d("main","call customAction1");
                String className = command.getClassName();
                String methodName = command.getMethodName();
                String callbackId = command.getCallbackId();
                JSONArray args = command.getArguments();
                Log.d("main","className:" + className);
                Log.d("main","methodName:" + methodName);
                Log.d("main","callbackId:" + callbackId);
                Log.d("main","args size:" + args.length());
                int arg0 = args.getInt(0);
                String arg1 = args.getString(1);
                PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"" + arg0 + "" + arg1);
                delegate.sendPluginResult(result,command.getCallbackId());
            }
        });
    }

    private void initX5WebView() {
        webView = findViewById(R.id.webview);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClient());
        WebView.setWebContentsDebuggingEnabled(true);
        bridge = new WebViewBridge(webView);
        TestPlugin plugin = new TestPlugin();
        CallbackPlugin callbackPlugin = new CallbackPlugin();
        bridge.registerPlugin(plugin);
        bridge.registerPlugin(callbackPlugin);
        bridge.registerPlugin(new EchoPlugin0());
        bridge.registerPlugin(new EchoPlugin1());
        bridge.registerAction("customAction1", new ActionCallback() {
            @Override
            public void onExec(InvokeUrlCommand command, CommandDelegate delegate) throws JSONException {
                Log.d("main","call customAction1");
                String className = command.getClassName();
                String methodName = command.getMethodName();
                String callbackId = command.getCallbackId();
                JSONArray args = command.getArguments();
                Log.d("main","className:" + className);
                Log.d("main","methodName:" + methodName);
                Log.d("main","callbackId:" + callbackId);
                Log.d("main","args size:" + args.length());
                int arg0 = args.getInt(0);
                String arg1 = args.getString(1);
                PluginResult result = PluginResult.resultWithString(CommandStatus.CDVCommandStatus_OK,"" + arg0 + "" + arg1);
                delegate.sendPluginResult(result,command.getCallbackId());
            }
        });
    }

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initSystemWebView();
        initX5WebView();
        load();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            load();
        } else {
            Log.d("main","...");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        bridge.dispose();
        systemBridge.dispose();
    }

    public void load() {
        webView.loadUrl("file:///android_asset/www/main/index1.html");
        systemWebView.loadUrl("file:///android_asset/www/main/index1.html");
    }
}
