class RCJSBridgeClass {

    constructor() {
        this._isDebug = false;
        this.rcCommandStatus = {
            CDVCommandStatus_NO_RESULT: 0,
            CDVCommandStatus_OK: 1,
            CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION: 2,
            CDVCommandStatus_INVALID_ACTION: 3,
            CDVCommandStatus_NATIVE_METHOD_EXCEPTION: 4,
            CDVCommandStatus_ERROR: 5
        };
        this._successMap = {};
        this._errorMap = {};
        this._callbackIndex = 0;
        this._b64_6bit = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        this._b64_12bit = this._b64_12bitTable();
        this.platform = this.checkPlatform();
    }

    _b64_12bitTable() {
        let b64_12bit = [];
        for (var i = 0; i < 64; i++) {
            for (var j = 0; j < 64; j++) {
                b64_12bit[i * 64 + j] = this._b64_6bit[i] + this._b64_6bit[j];
            }
        }
        return b64_12bit;
    }

    checkPlatform() {
        let ua = window.navigator.userAgent;
        let pattern = /RCAndroid/;
        if (pattern.test(ua)) {
            return 'android';
        } else {
            return 'ios';
        }
    }


    exec(success = null, error = null, service, action, args = []) {

        if (success === null) {
            console.log("JsBridge null success function");
            return;    
        }

        if (error === null) {
            console.log("JsBridge null error function");
            return;
        }

        if (service === null) {
            console.log("JsBridge null service");
            return;
        }

        if (action === null) {
            console.log("JsBridge null action");
            return;
        }

        if (args === null) {
            console.log("JsBridge null args");
            return;
        }

        this._callbackIndex++;
        if (this._callbackIndex === Number.MAX_SAFE_INTEGER) {
            this._callbackIndex = 0;
        }

        let callbackId = 'rc' + this._callbackIndex.toString() + Date.now();
        // 保证args是一个数组
        if (args === null) {
            args = [];
        }
        args = this._massageArgsJsToNative(args);
        this._successMap[callbackId] = success;
        this._errorMap[callbackId] = error;
        this._logMap(this._successMap);
        this._logMap(this._errorMap);
        let command = [callbackId, service, action, args];
        
        if (this.platform === 'ios') {
            window.webkit.messageHandlers.RCJSBridgeHandler.postMessage(command);
        } else {
            RCAndroidJSBridgeHandler.jsBridgeHandler(JSON.stringify(command));
        }
    }

    nativeCallback(callbackId, status, keepCallback, argumentsAsJson) {

        if (callbackId === null || callbackId === '') {
            return;
        }

        let success = this._successMap[callbackId];
        let error = this._errorMap[callbackId];
        if (success === null || success === 'undefined') {
            return;
        }
        // native端需要js端保持这个回调状态，因为native端需要
        // 向js端持续不断的发送消息
        // 这里会有一个潜在的bug，当native端结束向js端发送消息，并且没有
        // 将keepCallback置为false的话，会导致js端发生内存泄漏。
        if (!Boolean(keepCallback)) {
            delete this._successMap[callbackId];
            delete this._errorMap[callbackId];
            this._logMap(this._successMap);
            this._logMap(this._errorMap);
        }
        let response = {};
        response.status = status;
        response.data = argumentsAsJson === null ? null : this._massageMessageNativeToJs(argumentsAsJson);
        if (status === this.rcCommandStatus.CDVCommandStatus_OK) {
            setTimeout(success, 0, response);
        } else {
            setTimeout(error, 0, response);
        }
    }

    callAction(success, error, action, args) {
        args.push(action);
        this.exec(success, error, 'RCActionHandler#12306', 'globalAction', args);
    }

    // -------------------------------------------------------------------------------------------------------------------

    _massageArgsJsToNative(args) {
        let ret = [];
        args.forEach(arg => {
            if (this._typeName(arg) === 'ArrayBuffer') {
                ret.push({
                    'CDVType': 'ArrayBuffer',
                    'data': this._fromArrayBuffer(arg)
                });
            } else {
                ret.push(arg);
            }
        });
        return ret;
    }

    _massageMessageNativeToJs(message) {
        if (message.CDVType === 'ArrayBuffer') {
            // 将base64转为ArrayBuffer
            return this._toArrayBuffer(message.data);
        }

        if (message.CDVType === 'Void') {
            // native端没有返回值
            return null;
        }
        
        return message;
    }

    // base64转为ArrayBuffer
    _toArrayBuffer(b64) {
        let raw = atob(b64);
        let ret = new Uint8Array(raw.length);
        for (let i = 0; i < raw.length; i++) {
            ret[i] = raw.charCodeAt(i);
        }
        return ret.buffer;
    }

    // ArrayBuffer转为base64
    _fromArrayBuffer(arrayBuffer) {

        let array = new Uint8Array(arrayBuffer);

        function uint8ToBase64(rawData, b64_12bit, b64_6bit) {
            let numBytes = rawData.byteLength;
            let output = '';
            let segment;
            //let table = this._b64_12bit;
            let i;
            for (i = 0; i < numBytes - 2; i += 3) {
                segment = (rawData[i] << 16) + (rawData[i + 1] << 8) + rawData[i + 2];
                output += b64_12bit[segment >> 12];
                output += b64_12bit[segment & 0xfff];
            }
            if (numBytes - i === 2) {
                segment = (rawData[i] << 16) + (rawData[i + 1] << 8);
                output += b64_12bit[segment >> 12];
                output += b64_6bit[(segment & 0xfff) >> 6];
                output += '=';
            } else if (numBytes - i === 1) {
                segment = (rawData[i] << 16);
                output += b64_12bit[segment >> 12];
                output += '==';
            }
            return output;
        }
        return uint8ToBase64(array, this._b64_12bit, this._b64_6bit);
    }

    _typeName(val) {
        return Object.prototype.toString.call(val).slice(8, -1);
    }

    _log(msg) {
        if (this._isDebug) {
            console.log(msg);
        }
    }

    _logMap(myMap) {
        if (this._isDebug) {
            if (Object.keys(myMap).length == 0) {
                console.log("myMap size == 0!!");
                return;
            }
            console.log("print key and value");
            Object.keys(myMap).forEach((key) => {
                console.log(key + " ->" + myMap[key]);
            });
        }
    }
}
window.RCJSBridge = new RCJSBridgeClass();
if (window.RCJSBridgeInitFinishCallback !== null && window.RCJSBridgeInitFinishCallback !== 'undefined') {
	window.RCJSBridgeInitFinishCallback()
}
