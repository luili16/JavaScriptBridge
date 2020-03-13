package com.llx278.jsbridge;


import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.Map;

public class PluginHolder {
    final BasePlugin plugin;
    final Map<String, Method> jsMethods;
    final Map<String,ThreadMode> modes;

    public PluginHolder(@NonNull BasePlugin plugin, @NonNull Map<String, Method> jsMethods,@NonNull Map<String,ThreadMode> modes) {
        this.plugin = plugin;
        this.jsMethods = jsMethods;
        this.modes = modes;
    }
}
