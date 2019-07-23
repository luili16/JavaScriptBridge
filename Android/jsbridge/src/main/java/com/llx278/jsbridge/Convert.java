package com.llx278.jsbridge;

import android.text.TextUtils;
import android.util.Base64;

import org.json.JSONObject;

public class Convert {
    public static byte[] toBytes(JSONObject object) {

        String type = object.optString("CDVType");
        if (TextUtils.isEmpty(type) || !type.equals("ArrayBuffer")) {
            return null;
        }

        String base64Data = object.optString("data");
        if (TextUtils.isEmpty(base64Data)) {
            return null;
        }

        return Base64.decode(base64Data,Base64.DEFAULT);
    }
}
