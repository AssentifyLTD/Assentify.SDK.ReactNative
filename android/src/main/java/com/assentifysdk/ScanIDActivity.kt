package com.assentifysdk

import android.content.Context
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
import com.assentify.sdk.ScanIDCard.IDCardCallback
import com.assentify.sdk.ScanIDCard.IDResponseModel
import com.assentify.sdk.ScanIDCard.IDExtractedModel
import com.assentify.sdk.ScanIDCard.ScanIDCard
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.facebook.react.bridge.ReactApplicationContext
import pl.droidsonroids.gif.GifImageView
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import ImageToBase64Converter
import android.content.Intent
import com.assentify.sdk.RemoteClient.Models.SubmitRequestModel
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule

class ScanIDActivity: AppCompatActivity(),
  IDCardCallback {


  private lateinit var reactApplicationContext: ReactApplicationContext
  private lateinit var assentifySdk: AssentifySdk
  private lateinit var scanID: ScanIDCard
  private lateinit var infoText: TextView
  private lateinit var infoIcon: ImageView
  private lateinit var infoLayout: LinearLayout
  private lateinit var popUpContainer: LinearLayout
  private lateinit var popUpIcon: ImageView
  private lateinit var flippingCard: GifImageView
  private lateinit var popUpText: TextView
  private lateinit var popUpSubText: TextView
  private lateinit var idGif: LinearLayout
  private lateinit var jsonStringKycDocumentDetails: String;
  private lateinit var holdHandColor: String;
  private lateinit var processingColor: String;
  private lateinit var language: String;
  private lateinit var title: String;
  private  var isFlippingCard: Boolean = false;
  private lateinit var kycDocumentDetails: List<KycDocumentDetails>;
  private lateinit var popUpButton: Button
  private var start: Boolean = false;
  private var frontModel: IDResponseModel? = null
  private  var showCountDown: Boolean = true;
  val values: MutableMap<String, String> = mutableMapOf()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_scan)
    reactApplicationContext =  ReactApplicationContextObject.getReactApplicationContextObject()
    val jsonStringKycDocumentDetails = intent.getSerializableExtra("kycDocumentDetails") as String
    val gson = Gson()
    val listType = object : TypeToken<List<KycDocumentDetails>>() {}.type
    kycDocumentDetails = gson.fromJson(jsonStringKycDocumentDetails, listType)


    holdHandColor = intent.getStringExtra("holdHandColor")!!
    processingColor = intent.getStringExtra("processingColor")!!
    language = intent.getStringExtra("language")!!
    title = intent.getStringExtra("title")!!
    isFlippingCard = intent.getBooleanExtra("flippingCard",false)!!
    showCountDown = intent.getBooleanExtra("showCountDown",true)
    startAssentifySdk()



    val backButton = findViewById<RelativeLayout>(R.id.backButton)
    val drawable = getResources().getDrawable(R.drawable.rounded_background)
    drawable?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    backButton.setBackground(drawable)

    backButton.setOnClickListener {
      runOnUiThread {
        triggerEvent("onBackClick", null)
        scanID.stopScanning();
        finish()
      }
    }


    infoLayout = findViewById<LinearLayout>(R.id.infoLayout)
    val drawableInfo = getResources().getDrawable(R.drawable.info_rounded_background)
    drawableInfo?.setColorFilter(Color.parseColor(holdHandColor), PorterDuff.Mode.SRC_ATOP)
    infoLayout.setBackground(drawableInfo)


    flippingCard = findViewById<GifImageView>(R.id.flippingCard)
    flippingCard.visibility = View.GONE

    val toolbarTitle = findViewById<TextView>(R.id.toolbar_title)
    toolbarTitle.setText(title)
    toolbarTitle.setTextColor(Color.parseColor(processingColor))


    infoText = findViewById(R.id.infoText)
    infoText.setText("Please present ID")
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
      if(!start){
        popUpContainer.visibility = View.GONE
      }
    }
  }



  fun showPopUpMessage(icon: Int, title: String, subTitle: String, isSending: Boolean) {
    popUpContainer.visibility = View.VISIBLE

    popUpIcon = findViewById<ImageView>(R.id.popUpIcon)
    popUpIcon.setImageDrawable(getResources().getDrawable(icon))

    idGif = findViewById<LinearLayout>(R.id.idGif)

    popUpText = findViewById(R.id.popUpText)
    popUpText.setText(title)
    popUpText.setTextColor(Color.parseColor(processingColor))

    popUpSubText = findViewById(R.id.popUpSubText)
    popUpSubText.setText(subTitle)
    popUpSubText.setTextColor(Color.parseColor(processingColor))

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

    idGif.visibility = View.GONE
    popUpIcon.visibility = View.GONE
    popUpSubText.visibility = View.GONE
    popUpButton.visibility = View.GONE


    if (isSending) {
      idGif.visibility = View.VISIBLE
    } else {
      popUpIcon.visibility = View.VISIBLE
      popUpSubText.visibility = View.VISIBLE
      popUpButton.visibility = View.VISIBLE
    }


  }

  fun hidePopUpMessage() {
    start = false;
    popUpContainer.visibility = View.GONE
  }

  fun startAssentifySdk() {
    assentifySdk = AssentifySdkObject.getAssentifySdkObject();
    scanID = assentifySdk!!.startScanIDCard(
      this@ScanIDActivity,kycDocumentDetails,language
    );
    Thread.sleep(500);
    var fragmentManager = supportFragmentManager
    var transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.fragmentContainer, scanID)
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
      showPopUpMessage(
        R.drawable.id_warning,
        "Failed ID Check",
        "Please real ID (Not copy)",
        false
      )
    }
  }


  override fun onComplete(dataModel: IDResponseModel, order: Int) {

    triggerCompleteEvent("onComplete",dataModel.iDExtractedModel!!)

      values.putAll(convertMap(dataModel.iDExtractedModel!!.transformedProperties))


      if(kycDocumentDetails.size > 1){
        if(order == kycDocumentDetails.size -1 ){
          scanID.stopScanning();
          /** Data To Submit **/
          val sharedStepDefinitions =
            getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
          val gson = Gson()
          val json: String = sharedStepDefinitions.getString("Steps", "")!!
          val steps: List<StepDefinitions>? =
            gson.fromJson(json, object : TypeToken<List<StepDefinitions>>() {}.type)
          steps!!.forEach { item ->
            if (item.stepDefinition == StepsName.DocumentCapture) {
              val documentCaptureModel = SubmitRequestModel(
                item.stepId!!, item.stepDefinition,
                values
              );
              val documentCaptureSharedPreferences =
                getSharedPreferences(
                  "DocumentCaptureStepModel",
                  Context.MODE_PRIVATE
                )
              val documentCaptureSharedPreferencesEditor =
                documentCaptureSharedPreferences.edit()
              val documentCaptureGson = Gson()
              val documentCaptureStep: String =
                documentCaptureGson.toJson(documentCaptureModel)
              documentCaptureSharedPreferencesEditor.putString(
                "DocumentCaptureStep",
                documentCaptureStep
              );
              documentCaptureSharedPreferencesEditor.apply()
            }
          }
          /** **/
          var base64Image = ImageToBase64Converter().execute(frontModel!!.iDExtractedModel!!.imageUrl).get()
          val sharedPreferences = reactApplicationContext.getSharedPreferences("FaceMatch", Context.MODE_PRIVATE)
          val editor = sharedPreferences.edit()
          editor.putString("Base64SecondImage", base64Image)
          editor.apply()
          val intent = Intent(reactApplicationContext, FaceMatchActivity::class.java)
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
          intent.putExtra("holdHandColor", holdHandColor)
          intent.putExtra("processingColor", processingColor)
          intent.putExtra("showCountDown", showCountDown)
          reactApplicationContext?.startActivity(intent)
        }else{
          if(order==0){
            frontModel = dataModel;
            start = false;
          }
          hidePopUpMessage()
          if(isFlippingCard){
            flippingCard.visibility = View.VISIBLE
            val backgroundThread = Thread {
              try {
                Thread.sleep(5000)
                runOnUiThread{
                  flippingCard.visibility = View.GONE
                }
              } catch (e: InterruptedException) {
                e.printStackTrace()
              }
            }
            backgroundThread.start()
          }
        }
      }else{
        scanID.stopScanning();
        /** Data To Submit **/
        val sharedStepDefinitions =
          getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
        val gson = Gson()
        val json: String = sharedStepDefinitions.getString("Steps", "")!!
        val steps: List<StepDefinitions>? =
          gson.fromJson(json, object : TypeToken<List<StepDefinitions>>() {}.type)
        steps!!.forEach { item ->
          if (item.stepDefinition == StepsName.DocumentCapture) {
            val documentCaptureModel = SubmitRequestModel(
              item.stepId!!, item.stepDefinition,
              values
            );
            val documentCaptureSharedPreferences =
              getSharedPreferences(
                "DocumentCaptureStepModel",
                Context.MODE_PRIVATE
              )
            val documentCaptureSharedPreferencesEditor =
              documentCaptureSharedPreferences.edit()
            val documentCaptureGson = Gson()
            val documentCaptureStep: String =
              documentCaptureGson.toJson(documentCaptureModel)
            documentCaptureSharedPreferencesEditor.putString(
              "DocumentCaptureStep",
              documentCaptureStep
            );
            documentCaptureSharedPreferencesEditor.apply()
          }
        }
        /** **/
        var base64Image = ImageToBase64Converter().execute(dataModel.iDExtractedModel!!.imageUrl).get()
        val sharedPreferences = reactApplicationContext.getSharedPreferences("FaceMatch", Context.MODE_PRIVATE)
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

  override fun onWrongTemplate(dataModel: BaseResponseDataModel) {
    triggerEvent("onWrongTemplate", dataModel);
    runOnUiThread {
      start = false;
      showPopUpMessage(R.drawable.warning, "Wrong Template", "Let's try again", false)
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
            infoText.setText("Move ID Closer")
            infoIcon.setImageDrawable(getResources().getDrawable(R.drawable.zoom_in))
          }
          if (zoomType == ZoomType.ZOOM_OUT) {
            infoText.setText("Move ID Further")
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
            infoText.setText("Please present ID")
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


  private fun triggerCompleteEvent(eventName:String, dataModel: IDExtractedModel?){
      val eventResultMap = Arguments.createMap().apply {
        if(dataModel!=null){
          val gson = Gson()
          val jsonString = gson.toJson(dataModel!!)
          putString("IdDataModel", jsonString)
        }
      }
      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit(eventName, eventResultMap)


  }
  private fun triggerEvent(eventName:String, dataModel: BaseResponseDataModel?){
      val eventResultMap = Arguments.createMap().apply {
        if(dataModel!=null){
          putString("IdDataModel", dataModel.response)
        }
      }
      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit(eventName, eventResultMap)


  }

}
