package com.llx278.jsbridge;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Locale;

public class PluginResult {
    private final CommandStatus status;
    private final Object message;

    public static PluginResult resultWithStatus(CommandStatus status) {
        return new PluginResult(status,null);
    }

    public static PluginResult resultWithString(CommandStatus status,String message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithNumber(CommandStatus status,Number message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithJsonArray(CommandStatus status, JSONArray message) {
        return new PluginResult(status,message);
    }

    public static PluginResult resultWithJsonObject(CommandStatus status, JSONObject message) {
        return new PluginResult(status,message);
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
        if (message instanceof String) {
            return String.format(Locale.CHINA,"\"%s\"",message);
        } else {
            return message.toString();
        }
    }
}
