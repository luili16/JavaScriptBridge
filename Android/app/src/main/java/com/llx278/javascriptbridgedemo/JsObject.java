package com.llx278.javascriptbridgedemo;

import android.util.Log;
import android.webkit.JavascriptInterface;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class JsObject {
    @JavascriptInterface
    public void action() {
        Log.d("main","call action");
    }

    @JavascriptInterface
    public void paramsString(String str) {
        Log.d("main","str is " + str);
    }

    @JavascriptInterface
    public void paramsInteger(Integer integer) {
        Log.d("main","integer is : " + integer);
    }

    @JavascriptInterface
    public void paramsMaxInteger(Integer integer) {
        Log.d("main","Max integer is : " + integer);
    }

    @JavascriptInterface
    public void paramsMinInteger(Integer integer) {
        Log.d("main","Min Integer is : " + integer);
    }

    @JavascriptInterface
    public void paramsInt(int i) {
        Log.d("main","int is: " + i);
    }

    @JavascriptInterface
    public void paramsMinInt(int i) {
        Log.d("main","min int is: " + i);
    }

    @JavascriptInterface
    public void paramsMaxInt(int i) {
        Log.d("main","max int is: " + i);
    }

    @JavascriptInterface
    public void paramsDouble(double d) {
        Log.d("main","double is :" + d);
    }

    @JavascriptInterface
    public void paramsByte(byte b) {
        Log.d("main","byte is: " + b);
    }

    @JavascriptInterface
    public void paramsChar(char c) {
        Log.d("main","char is: " + c);
    }

    @JavascriptInterface
    public void paramsArray(List<Object> list) {
        Log.d("main", "list is: " + list);
    }

    @JavascriptInterface
    public void paramsAsIntArray(int[] ints) {
        if (ints == null) {
            Log.d("main","int array is: null");
            return;
        }
        Log.d("main","int array is : " + Arrays.toString(ints));
    }

    @JavascriptInterface
    public void paramsDoubleArray(double[] doubles) {
        Log.d("main","double array is : " + Arrays.toString(doubles));
    }
}
