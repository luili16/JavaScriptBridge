package com.llx278.jsbridge;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface JavaScriptBridgeClass {
    /**
     * js端对应的类名
     */
    String className() default "";
}
