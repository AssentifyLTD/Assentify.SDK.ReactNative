package com.assentifysdk


import android.graphics.Color
import android.graphics.PorterDuff
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.assentify.sdk.AssentifySdk
import com.assentify.sdk.AssentifySdkObject
import com.assentify.sdk.Core.Constants.MotionType
import com.assentify.sdk.Core.Constants.ZoomType
import com.assentify.sdk.Models.BaseResponseDataModel
import com.assentify.sdk.Models.encodeBaseResponseDataModelToJson
import com.assentify.sdk.RemoteClient.Models.KycDocumentDetails
import com.assentify.sdk.FaceMatch.FaceMatchCallback
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import com.assentify.sdk.FaceMatch.FaceResponseModel
import com.assentify.sdk.FaceMatch.FaceMatch
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import pl.droidsonroids.gif.GifImageView
import com.assentify.sdk.RemoteClient.Models.SubmitRequestModel
import android.content.Context
import android.content.Intent
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import android.util.Log

class FaceMatchActivity: AppCompatActivity(),
  FaceMatchCallback {

private lateinit var assentifySdk: AssentifySdk
  private lateinit var reactApplicationContext: ReactApplicationContext
  private lateinit var faceMatch: FaceMatch
  private lateinit var infoText: TextView
  private lateinit var infoIcon: ImageView
  private lateinit var infoLayout: LinearLayout
  private lateinit var popUpContainer: LinearLayout
  private lateinit var popUpIcon: ImageView
  private lateinit var popUpText: TextView
  private lateinit var popUpSubText: TextView
  private lateinit var popUpButton: Button

  private lateinit var holdHandColor: String;
  private lateinit var processingColor: String;
  private  var showCountDown: Boolean = true;
  private var start: Boolean = false;



  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_face_scan)

      reactApplicationContext =  ReactApplicationContextObject.getReactApplicationContextObject()
    showCountDown = intent.getBooleanExtra("showCountDown",true)
    holdHandColor = intent.getStringExtra("holdHandColor")!!
    processingColor = intent.getStringExtra("processingColor")!!

    startAssentifySdk()

    val backButton = findViewById<RelativeLayout>(R.id.backButton)
    val drawable = getResources().getDrawable(R.drawable.rounded_background)
    drawable?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    backButton.setBackground(drawable)

    backButton.setOnClickListener {
      runOnUiThread {
        triggerEvent("onBackClick", null)
        faceMatch.stopScanning();
        finish()
      }
    }


    infoLayout = findViewById<LinearLayout>(R.id.infoLayout)
    val drawableInfo = getResources().getDrawable(R.drawable.info_rounded_background)
    drawableInfo?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    infoLayout.setBackground(drawableInfo)


    val toolbarTitle = findViewById<TextView>(R.id.toolbar_title)
    toolbarTitle.setText("Face Capture")
    toolbarTitle.setTextColor(Color.parseColor(processingColor))


    infoText = findViewById(R.id.infoText)
    infoText.setText("Please face within circle")
    infoText.setTextColor(Color.parseColor(processingColor))

    infoIcon = findViewById<ImageView>(R.id.info_icon)
    infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))



    popUpContainer = findViewById<LinearLayout>(R.id.popUpContainer)
    val drawablePopUpContainer = getResources().getDrawable(R.drawable.info_rounded_background)
    drawablePopUpContainer?.setColorFilter(
      Color.parseColor(holdHandColor),
      PorterDuff.Mode.SRC_ATOP
    )
    popUpContainer.setBackground(drawablePopUpContainer)
    popUpContainer.visibility = View.GONE
    popUpContainer.setOnClickListener {
      if (!start) {
        popUpContainer.visibility = View.GONE
      }
    }

  }


  fun showPopUpMessage(icon: Int, title: String, subTitle: String, isSending: Boolean) {
    popUpContainer.visibility = View.VISIBLE

    popUpIcon = findViewById<ImageView>(R.id.popUpIcon)
    popUpIcon.setImageDrawable(getResources().getDrawable(icon))
    popUpIcon.visibility = View.VISIBLE

    popUpText = findViewById(R.id.popUpText)
    popUpText.setText(title)
    popUpText.setTextColor(Color.parseColor(processingColor))

    popUpSubText = findViewById(R.id.popUpSubText)
    popUpSubText.visibility = View.GONE

    val drawablePopUpButton = getResources().getDrawable(R.drawable.button_rounded_background)
    drawablePopUpButton?.setColorFilter(Color.parseColor(processingColor), PorterDuff.Mode.SRC_ATOP)
    popUpButton= findViewById(R.id.popUpButton)
    popUpButton.setBackground(drawablePopUpButton)
    popUpButton.setTextColor(Color.parseColor(holdHandColor))

    popUpButton.setOnClickListener {
      if(!start){
        popUpContainer.visibility  = View.GONE
      }
    }

    if(isSending){
      popUpButton.visibility = View.GONE
    }else{
      popUpButton.visibility = View.VISIBLE
    }
    if (subTitle.isNotEmpty()) {
      popUpSubText.setText(subTitle)
      popUpSubText.setTextColor(Color.parseColor(processingColor))
      popUpSubText.visibility = View.VISIBLE
    }


  }

  fun hidePopUpMessage() {
    popUpContainer.visibility = View.GONE
  }

  fun startAssentifySdk() {
    val sharedPreferences = reactApplicationContext.getSharedPreferences("FaceMatch", Context.MODE_PRIVATE)
    val base64SecondImage = sharedPreferences.getString("Base64SecondImage", "")
    assentifySdk = AssentifySdkObject.getAssentifySdkObject();
    faceMatch = assentifySdk!!.startFaceMatch(
      this@FaceMatchActivity,
      base64SecondImage!!,
      showCountDown
    );
    Thread.sleep(500);
    var fragmentManager = supportFragmentManager
    var transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.fragmentContainer, faceMatch)
    transaction.commit()
    faceMatch.startScanning()
  }

  override fun onError(dataModel: BaseResponseDataModel) {
    triggerEvent("onError", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Unable to Match", "Let's try again", false)
    }
  }

  override fun onSend() {
    triggerEvent("onSend", null)
    runOnUiThread {
      start = true;
      runOnUiThread {
        showPopUpMessage(R.drawable.sending, "Transmitting", "", true)
      }
    }
  }

  override fun onRetry(dataModel: BaseResponseDataModel) {
    triggerEvent("onRetry", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Unable to Match", "Let's try again", false)
    }
  }

  override fun onLivenessUpdate(dataModel: BaseResponseDataModel) {
    triggerEvent("onLivenessUpdate", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Liveness Failed", "", false)
    }
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
      start = false
      faceMatch.stopScanning();
       finish()
    }
  }

  override fun onEnvironmentalConditionsChange(
    brightness: Double,
    motion: MotionType,
  ) {
    runOnUiThread {
      if (start == false) {
        infoLayout.visibility = View.VISIBLE
        if (motion == MotionType.HOLD_YOUR_HAND) {
          infoText.setText("Please Hold Your Hand")
          infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
        } else {
          if (motion == MotionType.SENDING) {
            infoText.setText("Hold Steady")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
          }
          if (motion == MotionType.NO_DETECT) {
            infoText.setText("Please face within circle")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
          }

        }
      } else {
        infoLayout.visibility = View.GONE;
      }
    }
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
