package com.llx278.jsbridge;

public enum  CommandStatus {
    CDVCommandStatus_NO_RESULT(0),
    CDVCommandStatus_OK(1),
    CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION(2),
    CDVCommandStatus_INVALID_ACTION(3),
    CDVCommandStatus_NATIVE_METHOD_EXCEPTION(4),
    CDVCommandStatus_ERROR(5);
    private int status;
    private CommandStatus(int status) {
        this.status = status;
    }

    public int getStatus() {
        return status;
    }
}
