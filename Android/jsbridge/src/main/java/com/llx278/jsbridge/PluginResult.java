package com.llx278.jsbridge;

import android.util.Base64;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;

public class PluginResult {

    @NonNull
    private final CommandStatus status;
    @NonNull
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

    private static JSONObject messageFromVoid() {
        JSONObject obj = new JSONObject();
        try {
            obj.put("CDVType","Void");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return obj;
    }

    public static PluginResult resultWithVoid(@NonNull CommandStatus status) {
        return new PluginResult(status,messageFromVoid());
    }

    public static PluginResult resultWithOkVoid() {
        return resultWithVoid(CommandStatus.CDVCommandStatus_OK);
    }

    public static PluginResult resultWithString(@NonNull CommandStatus status, @NonNull String message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithOkString(@NonNull String message) {
        return resultWithString(CommandStatus.CDVCommandStatus_OK,message);
    }

    public static PluginResult resultWithNumber(@NonNull CommandStatus status,@NonNull Number message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithOkNumber(@NonNull Number message) {
        return resultWithNumber(CommandStatus.CDVCommandStatus_OK,message);
    }

    public static PluginResult resultWithBoolean(@NonNull CommandStatus status,@NonNull Boolean message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithOkBoolean(@NonNull Boolean message) {
        return resultWithBoolean(CommandStatus.CDVCommandStatus_OK,message);
    }

    public static PluginResult resultWithJsonArray(@NonNull CommandStatus status, @NonNull JSONArray message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithOkJsonArray(@NonNull JSONArray message) {
        return resultWithJsonArray(CommandStatus.CDVCommandStatus_OK,message);
    }

    public static PluginResult resultWithJsonObject(@NonNull CommandStatus status, @NonNull JSONObject message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithOkJsonObject(@NonNull JSONObject message) {
        return resultWithJsonObject(CommandStatus.CDVCommandStatus_OK,message);
    }

    public static PluginResult resultWithArrayBuffer(@NonNull CommandStatus status, @NonNull byte[] buf) {
        return new PluginResult(status,messageFromArrayBuffer(buf));
    }

    public static PluginResult resultWithOkArrayBuffer(@NonNull byte[] buf) {
        return resultWithArrayBuffer(CommandStatus.CDVCommandStatus_OK,buf);
    }

    public @NonNull CommandStatus getStatus() {
        return status;
    }

    public @NonNull Object getMessage() {
        return message;
    }

    private PluginResult(@NonNull CommandStatus status, @NonNull Object message) {
        this.status = status;
        this.message = message;
    }
    public String argumentsAsJson() {

        if (message instanceof String) {
            return String.format(Locale.CHINA,"\"%s\"",message);
        } else {
            return message.toString();
        }
    }
}
