package com.llx278.jsbridge;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface JavaScriptBridgeMethod {
    /**
     * js端对应的方法名
     */
    String methodName() default "";
}
