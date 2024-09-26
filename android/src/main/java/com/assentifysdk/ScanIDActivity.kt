package com.assentifysdk

import AssentifySdk
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.assentify.sdk.Core.Constants.MotionType
import com.assentify.sdk.Core.Constants.ZoomType
import com.assentify.sdk.Models.BaseResponseDataModel
import com.assentify.sdk.ScanIDCard.IDCardCallback
import ImageToBase64Converter
import SubmitRequestModel
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RelativeLayout
import android.widget.TextView
import android.widget.VideoView
import androidx.appcompat.widget.Toolbar
import androidx.cardview.widget.CardView
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import com.assentify.sdk.ScanIDCard.ScanIDCard
import com.assentify.sdk.AssentifySdkObject
import com.assentify.sdk.RemoteClient.Models.KycDocumentDetails
import com.assentify.sdk.ScanIDCard.IDResponseModel

class ScanIDActivity: AppCompatActivity(),
  IDCardCallback {
private lateinit var assentifySdk: AssentifySdk
  private lateinit var reactApplicationContext: ReactApplicationContext
  private lateinit var idCardRotation:RelativeLayout
  private lateinit var videoView: VideoView
  private lateinit var scanId: ScanIDCard
  private lateinit var fragmentContainer: CardView
  private lateinit var infoText: TextView
  private var frontModel: IDResponseModel? = null
  private var start: Boolean = false;
  private lateinit var kycDocumentDetails: List<KycDocumentDetails>;

  val values: MutableMap<String, String> = mutableMapOf()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_scan)
    reactApplicationContext =  ReactApplicationContextObject.getReactApplicationContextObject()
    val jsonStringKycDocumentDetails = intent.getSerializableExtra("kycDocumentDetails") as String
    val gson = Gson()
    val listType = object : TypeToken<List<KycDocumentDetails>>() {}.type
    kycDocumentDetails = gson.fromJson(jsonStringKycDocumentDetails, listType)


    idCardRotation  = findViewById(R.id.idcard_rotation);
    videoView = findViewById(R.id.videoView)
    fragmentContainer = findViewById(R.id.fragmentContainer)
    infoText = findViewById(R.id.infoText)
    infoText.setText("Please Present Your ID")


    startAssentifySdk(kycDocumentDetails)

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


  fun startAssentifySdk(kycDocumentDetails: List<KycDocumentDetails>) {
    fragmentContainer.visibility = View.VISIBLE
    assentifySdk = AssentifySdkObject.getAssentifySdkObject();
     scanId = assentifySdk!!.startScanIDCard(
      this@ScanIDActivity,kycDocumentDetails
    );
    var fragmentManager = supportFragmentManager
    var transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.fragmentContainer, scanId)
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

  override fun onWrongTemplate(dataModel: BaseResponseDataModel) {
    triggerEvent("onWrongTemplate",null)
    start = false;
    println("onWrongTemplate runOnUiThread")
    runOnUiThread{
      println("onWrongTemplate finish")
      finish()
    }
  }

  override fun onRetry(dataModel: BaseResponseDataModel) {
    triggerEvent("onRetry",dataModel)
      start = false;

  }
  override fun onComplete(dataModel: IDResponseModel, order: Int) {


      values.putAll(convertMap(dataModel.iDExtractedModel!!.outputProperties))
      triggerCompleteEvent("onComplete",dataModel)
      /** End **/


      if(kycDocumentDetails.size > 1){
        if(order == 1){
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
          reactApplicationContext?.startActivity(intent)
        }else{
          frontModel = dataModel;
          start = false;
          infoText.setText("Please Present Your ID")
          fragmentContainer.visibility = View.INVISIBLE
          idCardRotation.visibility = View.VISIBLE
          val videoUri: Uri =
            Uri.parse("android.resource://" + packageName + "/" + R.raw.id_card_rotation)
          videoView.setVideoURI(videoUri)
          videoView.start()
          videoView.setOnCompletionListener { mp ->
            idCardRotation.visibility = View.GONE
            fragmentContainer.visibility = View.VISIBLE
          }
        }
      }else{

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
        reactApplicationContext?.startActivity(intent)
      }


  }

  override fun onEnvironmentalConditionsChange(
    brightness: Double,
    motion: MotionType,
    zoomType: ZoomType
  ) {
      val eventResultMap = Arguments.createMap()
      Log.e("onEnvironmentalConditionsChange",start.toString())

      if(fragmentContainer.visibility  == View.INVISIBLE){
        infoText.setText("")
      }
      else if(start){
        infoText.setText("Processing...")
        infoText.setTextColor(getResources().getColor(R.color.Green))
      }else{
        infoText.setTextColor(getResources().getColor(R.color.yellow))
        if (zoomType == ZoomType.NO_DETECT && motion == MotionType.NO_DETECT ) {
          infoText.setText("Please Present Your ID")
        }
        else if (zoomType != ZoomType.SENDING) {
          if (zoomType == ZoomType.ZOOM_IN) {
            start = false;
            infoText.setText("Please Move The ID\nCloser To The Camera")
          }
          if (zoomType == ZoomType.ZOOM_OUT) {
            start = false;
            infoText.setText("Please Move The ID\nAway From The Camera")
          }
        } else if (motion == MotionType.HOLD_YOUR_HAND) {
          start = false;
          infoText.setText("Please Hold Your Hand")
        } else {
          infoText.setText("Please Present Your ID")
        }
      }

      eventResultMap.putBoolean("start", start)
      eventResultMap.putString("zoomType", zoomType.toString())
      eventResultMap.putString("motion", motion.toString())
      eventResultMap.putDouble("brightness", brightness)

      val result = Arguments.createMap().apply {
        putMap("IdDataModel", eventResultMap)
      }

      reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
        .emit("onEnvironmentalConditionsChange", result)

  }

  fun convertMap(map: Map<String, Any>?): Map<String, String> {
    return map?.mapValues {
      it.value.toString()
    } ?: emptyMap()
  }


  private fun triggerCompleteEvent(eventName:String, dataModel: IDResponseModel?){
      val eventResultMap = Arguments.createMap().apply {
        if(dataModel!=null){
          val gson = Gson()
          val jsonString = gson.toJson(dataModel.iDExtractedModel!!)
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
