package com.llx278.jsbridge;

import android.util.Base64;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;

public class PluginResult {
    private final CommandStatus status;
    private final Object message;

    private static JSONObject messageFromArrayBuffer(byte[] bytes) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("CDVType","ArrayBuffer");
            String base64 = Base64.encodeToString(bytes,Base64.DEFAULT);
            obj.put("data",base64);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return obj;
    }

    public static PluginResult resultWithStatus(CommandStatus status) {
        return new PluginResult(status,null);
    }

    public static PluginResult resultWithString(CommandStatus status,String message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithNumber(CommandStatus status,Number message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithBoolean(CommandStatus status,Boolean message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithJsonArray(CommandStatus status, JSONArray message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithJsonObject(CommandStatus status, JSONObject message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithArrayBuffer(CommandStatus status, byte[] buf) {
        return new PluginResult(status,messageFromArrayBuffer(buf));
    }

    public CommandStatus getStatus() {
        return status;
    }

    public Object getMessage() {
        return message;
    }

    private PluginResult(CommandStatus status, Object message) {
        this.status = status;
        this.message = message;
    }
    public String argumentsAsJson() {

        if (message == null) {
            return "";
        }

        if (message instanceof String) {
            return String.format(Locale.CHINA,"\"%s\"",message);
        } else {
            return message.toString();
        }
    }
}
