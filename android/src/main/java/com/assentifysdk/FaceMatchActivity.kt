package com.assentifysdk

import AssentifySdk
import SubmitRequestModel
import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.widget.Toolbar
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.assentify.sdk.Core.Constants.MotionType
import com.assentify.sdk.FaceMatch.FaceMatchCallback
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import com.assentify.sdk.AssentifySdkObject
import com.assentify.sdk.FaceMatch.FaceResponseModel
import com.assentify.sdk.Models.BaseResponseDataModel


class FaceMatchActivity: AppCompatActivity(),
  FaceMatchCallback {
private lateinit var assentifySdk: AssentifySdk
  private lateinit var reactApplicationContext: ReactApplicationContext
  private var base64SecondImage: String? = ""
  private lateinit var infoText: TextView
  private var start: Boolean = false;
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_scan)
      reactApplicationContext =  ReactApplicationContextObject.getReactApplicationContextObject()
     infoText = findViewById(R.id.infoText)
    infoText.setText("Position your face within\n\t\t\tthe center of screen")
     startAssentifySdk()
    val toolbar: Toolbar = findViewById(R.id.toolbar)
    setSupportActionBar(toolbar)
    supportActionBar?.setDisplayHomeAsUpEnabled(true)
    supportActionBar?.setDisplayShowTitleEnabled(false)
    val colorStateList = resources.getColorStateList(R.color.white)
    toolbar.navigationIcon?.setTintList(colorStateList)
    toolbar.setNavigationOnClickListener {  runOnUiThread{
      finish()
    } }
  }


  fun startAssentifySdk() {
    assentifySdk = AssentifySdkObject.getAssentifySdkObject();
    val sharedPreferences = reactApplicationContext.getSharedPreferences("FaceMatch", Context.MODE_PRIVATE)
    base64SecondImage = sharedPreferences.getString("Base64SecondImage", "")
    var scanFace = assentifySdk!!.startFaceMatch(
      this@FaceMatchActivity,
      base64SecondImage!!
    );
    var fragmentManager = supportFragmentManager
    var transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.fragmentContainer, scanFace)
    transaction.commit()

  }

  override fun onError(dataModel: BaseResponseDataModel) {
    triggerEvent("onError", dataModel)
      start = false;

  }

  override fun onSend() {
    triggerEvent("onSend", null)
      start = true;

  }

  override fun onRetry(dataModel: BaseResponseDataModel) {
    triggerEvent("onRetry",dataModel)
      start = false;

  }

  override fun onComplete(dataModel: FaceResponseModel) {
    triggerCompleteEvent("onComplete",dataModel)
    val sharedStepDefinitions =
      reactApplicationContext.getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
    val gson = Gson()
    val json: String = sharedStepDefinitions.getString("Steps", "")!!
    val steps: List<StepDefinitions>? =
      gson.fromJson(json, object : TypeToken<List<StepDefinitions>>() {}.type)
    steps!!.forEach { item ->
      if (item.stepDefinition == StepsName.FaceMatch) {
        val documentCaptureModel = SubmitRequestModel(
          item.stepId, StepsName.FaceMatch,
          convertMap(dataModel.faceExtractedModel!!.outputProperties)
        );
        val documentCaptureSharedPreferences =
          reactApplicationContext.getSharedPreferences("FaceMatchStepModel", Context.MODE_PRIVATE)
        val documentCaptureSharedPreferencesEditor = documentCaptureSharedPreferences.edit()
        val documentCaptureGson = Gson()
        val documentCaptureStep: String = documentCaptureGson.toJson(documentCaptureModel)
        documentCaptureSharedPreferencesEditor.putString(
          "FaceMatchStep",
          documentCaptureStep
        );
        documentCaptureSharedPreferencesEditor.apply()
      }
    }

    runOnUiThread{
      finish()
    }
  }

  override fun onEnvironmentalConditionsChange(
    brightness: Double,
    motion: MotionType,
  ) {
      val eventResultMap = Arguments.createMap()

      if(start){
        infoText.setText("Processing...")
        infoText.setTextColor(getResources().getColor(R.color.Green))
      }else{
        infoText.setTextColor(getResources().getColor(R.color.yellow))
        if ( motion == MotionType.NO_DETECT ) {
          infoText.setText("Position your face within\n\t\t\tthe center of screen")
        }
        else if (motion == MotionType.HOLD_YOUR_HAND) {
          start = false;
          infoText.setText("Please Hold Your Hand")
        } else {
            infoText.setText("Position your face within\n\t\t\tthe center of screen")
        }
      }

      eventResultMap.putBoolean("start", start)
      eventResultMap.putString("motion", motion.toString())
      eventResultMap.putDouble("brightness", brightness)

      val result = Arguments.createMap().apply {
        putMap("FaceMatchDataModel", eventResultMap)
      }

      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit("onEnvironmentalConditionsChange", result)

  }

  private fun triggerCompleteEvent(eventName:String, dataModel: FaceResponseModel?){
      val eventResultMap = Arguments.createMap().apply {
        if(dataModel!=null){
          val gson = Gson()
          val jsonString = gson.toJson(dataModel.faceExtractedModel!!)
          putString("FaceMatchDataModel", jsonString)
        }
      }
      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit(eventName, eventResultMap)


  }

  private fun triggerEvent(eventName:String, dataModel: BaseResponseDataModel?){
      val eventResultMap = Arguments.createMap().apply {
        if(dataModel!=null){
          putString("FaceMatchDataModel", dataModel.response)
        }
      }
      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit(eventName, eventResultMap)


  }

  fun convertMap(map: Map<String, Any>?): Map<String, String> {
    return map?.mapValues {
      it.value.toString()
    } ?: emptyMap()
  }


}
