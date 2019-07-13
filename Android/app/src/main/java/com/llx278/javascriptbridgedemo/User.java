package com.llx278.javascriptbridgedemo;

import java.util.Map;

public class User {
    private int acount;
    private boolean isCanUp;
    private Map<String,String> canUpdate;

    public User(int acount, boolean isCanUp, Map<String, String> canUpdate) {
        this.acount = acount;
        this.isCanUp = isCanUp;
        this.canUpdate = canUpdate;
    }

    public int getAcount() {
        return acount;
    }

    public void setAcount(int acount) {
        this.acount = acount;
    }

    public boolean isCanUp() {
        return isCanUp;
    }

    public void setCanUp(boolean canUp) {
        isCanUp = canUp;
    }

    public Map<String, String> getCanUpdate() {
        return canUpdate;
    }

    public void setCanUpdate(Map<String, String> canUpdate) {
        this.canUpdate = canUpdate;
    }


}
