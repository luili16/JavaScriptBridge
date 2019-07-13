var RCJSBridge = (function() {
	var isDebug = false;
	var rcCommandStatus = {
		CDVCommandStatus_NO_RESULT: 0,
		CDVCommandStatus_OK: 1,
		CDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION: 2,
		CDVCommandStatus_INVALID_ACTION: 3,
		CDVCommandStatus_ERROR: 4
	};

	var utils = (function() {
		var typeName = function(val) {
			return Object.prototype.toString.call(val).slice(8, -1);
		}

		return {
			typeName: typeName
		}
	})();
	// -------------------------------------------------------------
	// copy from cordova.js
	var base64 = (function() {
		fromArrayBuffer = function(arrayBuffer) {
			var array = new Uint8Array(arrayBuffer);
			return uint8ToBase64(array);
		};

		toArrayBuffer = function(str) {
			var decodedStr = typeof atob !== 'undefined' ? atob(str) : Buffer.from(str, 'base64').toString('binary'); // eslint-disable-line no-undef
			var arrayBuffer = new ArrayBuffer(decodedStr.length);
			var array = new Uint8Array(arrayBuffer);
			for (var i = 0, len = decodedStr.length; i < len; i++) {
				array[i] = decodedStr.charCodeAt(i);
			}
			return arrayBuffer;
		};

		/* This code is based on the performance tests at http://jsperf.com/b64tests
		 * This 12-bit-at-a-time algorithm was the best performing version on all
		 * platforms tested.
		 */

		var b64_6bit = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
		var b64_12bit;

		var b64_12bitTable = function() {
			b64_12bit = [];
			for (var i = 0; i < 64; i++) {
				for (var j = 0; j < 64; j++) {
					b64_12bit[i * 64 + j] = b64_6bit[i] + b64_6bit[j];
				}
			}
			b64_12bitTable = function() {
				return b64_12bit;
			};
			return b64_12bit;
		};

		function uint8ToBase64(rawData) {
			var numBytes = rawData.byteLength;
			var output = '';
			var segment;
			var table = b64_12bitTable();
			for (var i = 0; i < numBytes - 2; i += 3) {
				segment = (rawData[i] << 16) + (rawData[i + 1] << 8) + rawData[i + 2];
				output += table[segment >> 12];
				output += table[segment & 0xfff];
			}
			if (numBytes - i === 2) {
				segment = (rawData[i] << 16) + (rawData[i + 1] << 8);
				output += table[segment >> 12];
				output += b64_6bit[(segment & 0xfff) >> 6];
				output += '=';
			} else if (numBytes - i === 1) {
				segment = (rawData[i] << 16);
				output += table[segment >> 12];
				output += '==';
			}
			return output;
		}
		// ----------------------------------------------------------------------

		return {
			fromArrayBuffer: fromArrayBuffer,
			toArrayBuffer: toArrayBuffer
		}
	})();

	var callbackMap = {};
	var callbackIndex = 0;

	var globalExec = function rcGlobalExec(callback,action,args) {
		args.push(action);
		rcExecInternal(callback,"RCActionHandler#12306","globalAction",args);
	}

	var exec = function rcExec(callback, serviceName, action, args) {
		rcExecInternal(callback,serviceName,action,args);
	}
	
	function rcExecInternal(callback, serviceName, action, args) {
		callbackIndex++;
		if (callbackIndex === Number.MAX_INTEGER) {
			callbackIndex = 0;
		}
		var callbackId = 'rc' + callbackIndex.toString() + Date.now();
		// 保证arguemnts是一个数组
		args = args || [];
		args = massageArgsJsToNative(args);
		if (callback != null) {
			callbackMap[callbackId] = callback;
		} else {
			// callback是null，就说明不需要有返回值，那么callbackId就设为null
			callbackId = null;
		}
		var command = [callbackId, serviceName, action, args];
		debug(`callbackId : ${callbackId}`);
		debug(`serviceName: ${serviceName}`);
		debug(`action : ${action}`);
		debug(`arguments  : ${args}`);
		//debugMap(callbackMap);
		debug(callbackMap);
		if (RCJSBridgeHandler != null) {
			debug("we are at android webview");
			RCJSBridgeHandler.jsBridgeHandler(JSON.stringify(command));
		} else {
			debug("we are at ios webview");
			window.webkit.messageHandlers.RCJSBridgeHandler.postMessage(command);
		}
	}

	function massageArgsJsToNative(args) {
		if (!args || utils.typeName(args) != 'Array') {
			return args;
		}
		var ret = [];
		args.forEach(function(arg, i) {
			if (utils.typeName(arg) == 'ArrayBuffer') {
				ret.push({
					'CDVType': 'ArrayBuffer',
					'data': base64.fromArrayBuffer(arg)
				});
			} else {
				ret.push(arg);
			}
		});
		return ret;
	}

	function massageMessageNativeToJs(message) {
		if (message.CDVType == 'ArrayBuffer') {
			var stringToArrayBuffer = function(str) {
				var ret = new Uint8Array(str.length);
				for (var i = 0; i < str.length; i++) {
					ret[i] = str.charCodeAt(i);
				}
				return ret.buffer;
			};
			var base64ToArrayBuffer = function(b64) {
				return stringToArrayBuffer(atob(b64));
			};
			message = base64ToArrayBuffer(message.data);
		}
		return message;
	}

	var nativeCallback = function RCNativeCallback(callbackId, status, keepCallback, argumentsAsJson) {
		if (callbackId == null) {
			return;
		}
		var callback = callbackMap[callbackId];
		if (callback == null || callback == 'undefined') {
			return;
		}
		debug(`keepCallback : ${keepCallback}`);
		debug(`argumentsAsJson : ${argumentsAsJson}`);
		// native端需要js端保持这个回调状态，因为native端需要
		// 向js端持续不断的发送消息
		// 这里会有一个潜在的bug，当native端结束向js端发送消息，并且没有
		// 将keepCallback置为false的话，会导致js端发生内存泄漏。
		var keepCallbackObj = Boolean(keepCallback);
		if (!keepCallbackObj) {
			debug("delete callbackId: " + callbackId);
			//callbackMap.delete(callbackId);
			delete callbackMap[callbackId];
			debug(callbackMap);
		}
		var response = {}
		response.status = status;
		response.data = argumentsAsJson == null ? null : massageMessageNativeToJs(argumentsAsJson);
		// 不要阻塞当前的函数执行
		setTimeout(callback, 0, response);
	}

	function debug(msg) {
		if (isDebug) {
			console.log(msg);
		}
	}

	function debugMap(myMap) {
		if (isDebug) {
			// 			if (myMap.size === 0) {
			// 				console.log("map size == 0!");
			// 			}
			for (var [key, value] of myMap) {
				console.log(key + ' = ' + value);
			}
		}
	}

	return {
		callAction:globalExec,
		exec: exec,
		nativeCallback: nativeCallback,
		rcCommandStatus: rcCommandStatus
	}
})();
