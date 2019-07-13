"use strict";

function _instanceof(left, right) { if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) { return right[Symbol.hasInstance](left); } else { return left instanceof right; } }

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!_instanceof(instance, Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var RCJSBridgeClass =
/*#__PURE__*/
function () {
  function RCJSBridgeClass() {
    _classCallCheck(this, RCJSBridgeClass);

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
    this._b64_6bit = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    this._b64_12bit = this._b64_12bitTable();
  }

  _createClass(RCJSBridgeClass, [{
    key: "_b64_12bitTable",
    value: function _b64_12bitTable() {
      var b64_12bit = [];

      for (var i = 0; i < 64; i++) {
        for (var j = 0; j < 64; j++) {
          b64_12bit[i * 64 + j] = this._b64_6bit[i] + this._b64_6bit[j];
        }
      }

      return b64_12bit;
    }
  }, {
    key: "exec",
    value: function exec() {
      var success = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;
      var error = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
      var service = arguments.length > 2 ? arguments[2] : undefined;
      var action = arguments.length > 3 ? arguments[3] : undefined;
      var args = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : [];
      this._callbackIndex++;

      if (this._callbackIndex === Number.MAX_SAFE_INTEGER) {
        this._callbackIndex = 0;
      }

      var callbackId = 'rc' + this._callbackIndex.toString() + Date.now(); // 保证args是一个数组

      if (args === null) {
        args = [];
      }

      args = this._massageArgsJsToNative(args);

      if (success !== null) {
        //this._successMap.set(callbackId, success);
        this._successMap.callbackId = success; //this._errorMap.set(callbackId, error);

        this._errorMap.callbackId = error;
      } else {
        // success回调是null，就说明不需要有返回值，那么callbackId就设为null
        callbackId = null;
      }

      var command = [callbackId, service, action, args]; // TODO 这里需要根据不同的平台进行回调
      //window.webkit.messageHandlers.RCJSBridgeHandler.postMessage(command);

      RCAndroidJSBridgeHandler.jsBridgeHandler(JSON.stringify(command));
    }
  }, {
    key: "nativeCallback",
    value: function nativeCallback(callbackId, status, keepCallback, argumentsAsJson) {
      console.log("callbackId:" + callbackId);
      console.log("status:" + status);
      console.log("keepCallback:" + keepCallback);
      console.log("argumentsAsJson:" + argumentsAsJson.acount);
      console.log("argumentsAsJson:" + argumentsAsJson.toString());
      console.log("argumentsType: " + _typeof(argumentsAsJson));

      if (callbackId === null) {
        return;
      }

      var success = this._successMap.callbackId;
      var error = this._errorMap.callbackId;

      if (success === null || success === 'undefined') {
        return;
      } // native端需要js端保持这个回调状态，因为native端需要
      // 向js端持续不断的发送消息
      // 这里会有一个潜在的bug，当native端结束向js端发送消息，并且没有
      // 将keepCallback置为false的话，会导致js端发生内存泄漏。


      if (!Boolean(keepCallback)) {
        delete this._successMap.callbackId;
        delete this._errorMap.callbackId; //this._successMap.delete(callbackId);
        //this._errorMap.delete(callbackId);
      }

      var response = {};
      response.status = status;
      response.data = argumentsAsJson === null ? null : this._massageMessageNativeToJs(argumentsAsJson);

      if (status === this.rcCommandStatus.CDVCommandStatus_OK) {
        setTimeout(success, 0, response);
      } else {
        setTimeout(error, 0, response);
      }
    }
  }, {
    key: "callAction",
    value: function callAction(success, error, action, args) {
      args.push(action);
      this.exec(success, error, 'RCActionHandler#12306', 'globalAction', args);
    } // -------------------------------------------------------------------------------------------------------------------

  }, {
    key: "_massageArgsJsToNative",
    value: function _massageArgsJsToNative(args) {
      var _this = this;

      var ret = [];
      args.forEach(function (arg) {
        if (_this._typeName(arg) === 'ArrayBuffer') {
          ret.push({
            'CDVType': 'ArrayBuffer',
            'data': _this._fromArrayBuffer(arg)
          });
        } else {
          ret.push(arg);
        }
      });
      return ret;
    }
  }, {
    key: "_massageMessageNativeToJs",
    value: function _massageMessageNativeToJs(message) {
      if (message.CDVType !== 'ArrayBuffer') {
        return message;
      } // 将base64转为ArrayBuffer


      return this._toArrayBuffer(message.data);
    } // base64转为ArrayBuffer

  }, {
    key: "_toArrayBuffer",
    value: function _toArrayBuffer(b64) {
      var raw = atob(b64);
      var ret = new Uint8Array(raw.length);

      for (var i = 0; i < raw.length; i++) {
        ret[i] = raw.charCodeAt(i);
      }

      return ret.buffer;
    } // ArrayBuffer转为base64

  }, {
    key: "_fromArrayBuffer",
    value: function _fromArrayBuffer(arrayBuffer) {
      var array = new Uint8Array(arrayBuffer);

      function uint8ToBase64(rawData, b64_12bit, b64_6bit) {
        var numBytes = rawData.byteLength;
        var output = '';
        var segment; //let table = this._b64_12bit;

        var i;

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
          segment = rawData[i] << 16;
          output += b64_12bit[segment >> 12];
          output += '==';
        }

        return output;
      }

      return uint8ToBase64(array, this._b64_12bit, this._b64_6bit);
    }
  }, {
    key: "_typeName",
    value: function _typeName(val) {
      return Object.prototype.toString.call(val).slice(8, -1);
    }
  }]);

  return RCJSBridgeClass;
}();

window.RCPlatform = 'android';
window.RCJSBridge = new RCJSBridgeClass();