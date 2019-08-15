package com.llx278.javascriptbridgedemo;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.llx278.jsbridge.CommandDelegate;
import com.llx278.jsbridge.CommandStatus;
import com.llx278.jsbridge.PluginResult;
import com.llx278.jsbridge.WebViewBridge;
import com.llx278.jsbridge.plugin.ActionCallback;
import com.llx278.jsbridge.plugin.InvokeUrlCommand;

import org.json.JSONArray;
import org.json.JSONException;

public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private WebViewBridge bridge;

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
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
        if (ContextCompat.checkSelfPermission(this,Manifest.permission.INTERNET) == PackageManager.PERMISSION_GRANTED) {
           load();
        } else {
            ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.INTERNET},1);
        }

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
    }

    public void load() {
        webView.loadUrl("file:///android_asset/www/main/index1.html");
    }
}
