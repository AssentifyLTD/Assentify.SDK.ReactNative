package com.assentifysdk

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter

abstract class AssentifySdkBaseModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
  companion object {
    const val NAME = "AssentifySdk"
    private const val ERROR_KEY = "EventError"
  }

  override fun getName(): String {
    return NAME
  }

  val reactContext = context

  fun sendErrorObject(errorCode: String?, errorMsg: String?) {
      val errorResult = Arguments.createMap().apply {
          putString("errorCode", errorCode ?: "")
          putString("errorMessage", errorMsg ?: "")
      }
      sendEvent(ERROR_KEY, errorResult)
  }

  fun showErrorMessage(msg: String?) {
      val errorResult = Arguments.createMap().apply {
          putString("errorMessage", msg ?: "")
      }
      sendEvent(ERROR_KEY, errorResult)
  }

  fun sendEvent(eventName: String, params: WritableMap) =
      reactApplicationContext.getJSModule(RCTDeviceEventEmitter::class.java)
          .emit(eventName, params)
}
