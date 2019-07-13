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
        this._successMap = new Map();
        this._errorMap = new Map();
        this._callbackIndex = 0;
        this._b64_6bit = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        this._b64_12bit = this._b64_12bitTable();
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


    exec(success = null, error = null, service, action, args = []) {
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
        if (success !== null) {
            this._successMap.set(callbackId, success);
            this._errorMap.set(callbackId, error);
        } else {
            // success回调是null，就说明不需要有返回值，那么callbackId就设为null
            callbackId = null;
        }
        let command = [callbackId, service, action, args];
        // TODO 这里需要根据不同的平台进行回调

        //window.webkit.messageHandlers.RCJSBridgeHandler.postMessage(command);
        RCAndroidJSBridgeHandler.jsBridgeHandler(JSON.stringify(command));
    }

    nativeCallback(callbackId, status, keepCallback, argumentsAsJson) {

        console.log("callbackId:" + callbackId);
        console.log("status:" + status);
        console.log("keepCallback:" + keepCallback);
        console.log("argumentsAsJson:" + argumentsAsJson.acount);
        console.log("argumentsAsJson:" + argumentsAsJson.toString());
        console.log("argumentsType: " + typeof(argumentsAsJson));

        if (callbackId === null) {
            return;
        }

        let success = this._successMap.get(callbackId);
        let error = this._errorMap.get(callbackId);
        if (success === null || success === 'undefined') {
            return;
        }
        // native端需要js端保持这个回调状态，因为native端需要
        // 向js端持续不断的发送消息
        // 这里会有一个潜在的bug，当native端结束向js端发送消息，并且没有
        // 将keepCallback置为false的话，会导致js端发生内存泄漏。
        if (!Boolean(keepCallback)) {
            this._successMap.delete(callbackId);
            this._errorMap.delete(callbackId);
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
        if (message.CDVType !== 'ArrayBuffer') {
            return message;
        }
        // 将base64转为ArrayBuffer
        return this._toArrayBuffer(message.data);
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
}
window.RCJSBridge = new RCJSBridgeClass();
