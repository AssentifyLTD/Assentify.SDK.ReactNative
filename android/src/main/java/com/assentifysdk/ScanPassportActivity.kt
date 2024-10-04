package com.assentifysdk

import com.assentify.sdk.AssentifySdk
import com.assentify.sdk.RemoteClient.Models.SubmitRequestModel
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.assentify.sdk.Core.Constants.MotionType
import com.assentify.sdk.Core.Constants.ZoomType
import ImageToBase64Converter
import android.widget.TextView
import androidx.appcompat.widget.Toolbar
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import com.assentify.sdk.Models.BaseResponseDataModel
import com.assentify.sdk.ScanPassport.PassportResponseModel
import com.assentify.sdk.ScanPassport.ScanPassportCallback
import com.assentify.sdk.AssentifySdkObject
import com.assentify.sdk.ScanPassport.ScanPassport
import android.view.View
import android.widget.Button
import android.widget.ImageView
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.Date
import android.graphics.Color
import android.graphics.PorterDuff
import android.widget.LinearLayout
import android.widget.RelativeLayout
import java.text.SimpleDateFormat
import android.util.Log
class ScanPassportActivity : AppCompatActivity(),
  ScanPassportCallback {
  private lateinit var assentifySdk: AssentifySdk
  private lateinit var reactApplicationContext: ReactApplicationContext
  private lateinit var scanPassport: ScanPassport
  private lateinit var infoText: TextView
  private lateinit var infoIcon: ImageView
  private lateinit var infoLayout: LinearLayout
  private lateinit var popUpContainer: LinearLayout
  private lateinit var popUpIcon: ImageView
  private lateinit var popUpText: TextView
  private lateinit var popUpSubText: TextView
  private lateinit var passportGif: LinearLayout
  private lateinit var popUpButton: Button

  private lateinit var holdHandColor: String;
  private lateinit var processingColor: String;
  private lateinit var language: String;
  private  var showCountDown: Boolean = true;
  private var start: Boolean = false;
  private var isDone: Boolean = false;


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_scan)
    reactApplicationContext = ReactApplicationContextObject.getReactApplicationContextObject()
    holdHandColor = intent.getStringExtra("holdHandColor")!!
    processingColor = intent.getStringExtra("processingColor")!!
    language = intent.getStringExtra("language")!!
    showCountDown = intent.getBooleanExtra("showCountDown",true)

    startAssentifySdk()

    val backButton = findViewById<RelativeLayout>(R.id.backButton)
    val drawable = getResources().getDrawable(R.drawable.rounded_background)
    drawable?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    backButton.setBackground(drawable)

    backButton.setOnClickListener {
      runOnUiThread {
        triggerEvent("onBackClick", null)
        scanPassport.stopScanning();
        finish()
      }
    }


    infoLayout = findViewById<LinearLayout>(R.id.infoLayout)
    val drawableInfo = getResources().getDrawable(R.drawable.info_rounded_background)
    drawableInfo?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    infoLayout.setBackground(drawableInfo)


    val toolbarTitle = findViewById<TextView>(R.id.toolbar_title)
    toolbarTitle.setText("Passport Capture")
    toolbarTitle.setTextColor(Color.parseColor(processingColor))


    infoText = findViewById(R.id.infoText)
    infoText.setText("Please present passport")
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

    passportGif = findViewById<LinearLayout>(R.id.passportGif)

    popUpText = findViewById(R.id.popUpText)
    popUpText.setText(title)
    popUpText.setTextColor(Color.parseColor(processingColor))

    popUpSubText = findViewById(R.id.popUpSubText)
    popUpSubText.setTextColor(Color.parseColor(processingColor))


    val drawablePopUpButton = getResources().getDrawable(R.drawable.button_rounded_background)
    drawablePopUpButton?.setColorFilter(Color.parseColor(processingColor), PorterDuff.Mode.SRC_ATOP)
    popUpButton = findViewById(R.id.popUpButton)
    popUpButton.setBackground(drawablePopUpButton)
    popUpButton.setTextColor(Color.parseColor(holdHandColor))

    popUpButton.setOnClickListener {
      if (!start) {
        popUpContainer.visibility = View.GONE
      }
    }

    passportGif.visibility = View.GONE
    popUpIcon.visibility = View.GONE
    popUpSubText.visibility = View.GONE
    popUpButton.visibility = View.GONE

    if (isSending) {
      passportGif.visibility = View.VISIBLE
    } else {
      popUpIcon.visibility = View.VISIBLE
      popUpSubText.visibility = View.VISIBLE
      popUpButton.visibility = View.VISIBLE
    }


  }

  fun hidePopUpMessage() {
    popUpContainer.visibility = View.GONE
  }


  fun startAssentifySdk() {
    assentifySdk = AssentifySdkObject.getAssentifySdkObject();
    scanPassport = assentifySdk!!.startScanPassport(
      this@ScanPassportActivity,
      language
    );
    Thread.sleep(500);
    var fragmentManager = supportFragmentManager
    var transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.fragmentContainer, scanPassport)
    transaction.commit()

  }

  override fun onError(dataModel: BaseResponseDataModel) {
    triggerEvent("onError", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Unable to extract", "Let's try again", false)
    }
  }

  override fun onSend() {
    triggerEvent("onSend", null)
    runOnUiThread {
      start = true;
      runOnUiThread {
        showPopUpMessage(R.drawable.sending, "Transmitting", "Transmitting", true)
      }
    }
  }

  override fun onRetry(dataModel: BaseResponseDataModel) {
    triggerEvent("onRetry", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Unable to extract", "Let's try again", false)
    }
  }

  override fun onLivenessUpdate(dataModel: BaseResponseDataModel) {
    triggerEvent("onLivenessUpdate", dataModel)
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning,"Failed ID Check","Please real ID (Not copy)",false)
    }
  }

  override fun onComplete(dataModel: PassportResponseModel) {

    if (isExpired(dataModel.passportExtractedModel!!.identificationDocumentCapture!!.expiryDate.toString())) {
      runOnUiThread {
        start = false;
        showPopUpMessage(R.drawable.expire, "Expired", "Please provide valid ID", false)
      }
    } else {
      triggerCompleteEvent("onComplete", dataModel)
      /** Steps **/
      val sharedStepDefinitions =
        reactApplicationContext.getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
      val gson = Gson()
      val json: String = sharedStepDefinitions.getString("Steps", "")!!
      val steps: List<StepDefinitions>? =
        gson.fromJson(json, object : TypeToken<List<StepDefinitions>>() {}.type)
      steps!!.forEach { item ->
        if (item.stepDefinition == StepsName.DocumentCapture) {
          val documentCaptureModel = SubmitRequestModel(
            item.stepId, StepsName.DocumentCapture,
            convertMap(dataModel.passportExtractedModel!!.outputProperties)
          );
          val documentCaptureSharedPreferences = reactApplicationContext.getSharedPreferences(
            "DocumentCaptureStepModel",
            Context.MODE_PRIVATE
          )
          val documentCaptureSharedPreferencesEditor = documentCaptureSharedPreferences.edit()
          val documentCaptureGson = Gson()
          val documentCaptureStep: String = documentCaptureGson.toJson(documentCaptureModel)
          documentCaptureSharedPreferencesEditor.putString(
            "DocumentCaptureStep",
            documentCaptureStep
          );
          documentCaptureSharedPreferencesEditor.apply()
        }
        runOnUiThread {
          scanPassport.stopScanning();
          /** End **/
          if(!isDone){
            isDone = true;
            var base64Image =
              ImageToBase64Converter().execute(dataModel.passportExtractedModel!!.imageUrl).get()
            val sharedPreferences =
              reactApplicationContext.getSharedPreferences("FaceMatch", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putString("Base64SecondImage", base64Image)
            editor.apply()
            val intent = Intent(reactApplicationContext, FaceMatchActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("holdHandColor", holdHandColor)
            intent.putExtra("processingColor", processingColor)
            intent.putExtra("showCountDown", showCountDown)
            reactApplicationContext?.startActivity(intent)
          }


        }
      }
    }


  }

  override fun onEnvironmentalConditionsChange(
    brightness: Double,
    motion: MotionType,
    zoomType: ZoomType
  ) {
    runOnUiThread {
      if (start == false) {
        infoLayout.visibility = View.VISIBLE
        if (zoomType != ZoomType.SENDING && zoomType != ZoomType.NO_DETECT) {
          if (zoomType == ZoomType.ZOOM_IN) {
            infoText.setText("Move Passport Closer")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.zoom_in))
          }
          if (zoomType == ZoomType.ZOOM_OUT) {
            infoText.setText("Move Passport Further")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.zoom_out))
          }
        } else if (motion == MotionType.HOLD_YOUR_HAND) {
          infoText.setText("Please Hold Your Hand")
          infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
        } else {
          if (motion == MotionType.SENDING && zoomType == ZoomType.SENDING) {
            infoText.setText("Hold Steady")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
          }
          if (motion == MotionType.NO_DETECT && zoomType == ZoomType.NO_DETECT) {
            infoText.setText("Please present passport")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.info_icon))
          }

        }
      } else {
        infoLayout.visibility = View.GONE
      }

    }
  }


  fun convertMap(map: Map<String, Any>?): Map<String, String> {
    return map?.mapValues {
      it.value.toString()
    } ?: emptyMap()
  }

  private fun triggerCompleteEvent(eventName: String, dataModel: PassportResponseModel?) {
    val eventResultMap = Arguments.createMap().apply {
      if (dataModel != null) {
        val gson = Gson()
        val jsonString = gson.toJson(dataModel.passportExtractedModel!!)
        putString("PassportDataModel", jsonString)
      }
    }
    reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, eventResultMap)

  }

  private fun triggerEvent(eventName: String, dataModel: BaseResponseDataModel?) {
    val eventResultMap = Arguments.createMap().apply {
      if (dataModel != null) {
        putString("PassportDataModel", dataModel.response)
      }
    }
    reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, eventResultMap)

  }

  fun isExpired(date: String): Boolean {
    val sdf = SimpleDateFormat("dd/MM/yyyy")
    val currentDate: LocalDate = LocalDate.now()
    val formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy")
    val currentDateStr: String = currentDate.format(formatter)
    val parsedCurrentDate: Date = sdf.parse(currentDateStr)
    val dataDate = sdf.parse(date)
    if (parsedCurrentDate.after(dataDate)) {
      return true;
    }
    return false;
  }
}
