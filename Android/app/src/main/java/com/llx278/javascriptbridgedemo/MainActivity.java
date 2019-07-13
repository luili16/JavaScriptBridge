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

import com.llx278.jsbridge.WebViewBridge;

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
        WebView.setWebContentsDebuggingEnabled(true);
        bridge = new WebViewBridge(webView);
        TestPlugin plugin = new TestPlugin();
        bridge.registerPlugin(plugin);
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
