package com.assentifysdk

import com.assentify.sdk.AssentifySdk
import com.assentify.sdk.AssentifySdkCallback
import com.assentify.sdk.AssentifySdkObject
import BlockLoaderKeys
import StepsName
import com.assentify.sdk.RemoteClient.Models.SubmitRequestModel
import WrapUpKeys
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.assentify.sdk.Core.Constants.EnvironmentalConditions
import com.assentify.sdk.RemoteClient.Models.ConfigModel
import com.assentify.sdk.RemoteClient.Models.StepDefinitions
import com.assentify.sdk.RemoteClient.Models.TemplatesByCountry
import com.assentify.sdk.RemoteClient.Models.encodeTemplatesByCountryToJson
import com.assentify.sdk.SubmitData.SubmitDataCallback
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableType
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import com.assentify.sdk.RemoteClient.Models.KycDocumentDetails


class AssentifySdkModule(context: ReactApplicationContext) :
    AssentifySdkBaseModule(context), AssentifySdkCallback, SubmitDataCallback {

  private lateinit var assentifySdk: AssentifySdk
  private lateinit var timeStarted: String
  private lateinit var apiKey: String
  private lateinit var configModel: ConfigModel
  private val mainHandler = Handler(Looper.getMainLooper())
  private lateinit var environmentalConditions: EnvironmentalConditions
  private lateinit var templatesByCountry: List<TemplatesByCountry>
  @ReactMethod
  fun initialize(
      apiKey: String,
      tenantIdentifier: String,
      instanceHash: String,
      processMrz: Boolean? = null,
      storeCapturedDocument: Boolean? = null,
      performLivenessDetection: Boolean? = null,
      storeImageStream: Boolean? = null,
      saveCapturedVideoID: Boolean? = null,
      saveCapturedVideoFace: Boolean? = null,
      ENV_BRIGHTNESS_HIGH_THRESHOLD: Float? = null,
      ENV_BRIGHTNESS_LOW_THRESHOLD: Float? = null,
      ENV_PREDICTION_LOW_PERCENTAGE: Float? = null,
      ENV_PREDICTION_HIGH_PERCENTAGE: Float? = null,
      ENV_CustomColor: String? = null,
      ENV_HoldHandColor: String? = null,
      enableDetect: Boolean = true,
      enableGuide: Boolean = true,
  ) {
    try {
      if (apiKey.isNullOrBlank() ||
              tenantIdentifier.isNullOrBlank() ||
              instanceHash.isNullOrBlank()
      ) {
        Log.e(NAME, "apiKey, tenantIdentifier and instanceHash are mandatory parameters")
        return
      }

      this.apiKey = apiKey
      println("initialize - Assentify SDK initialize")
      println("apiKey: $apiKey")
      println("tenantIdentifier: $tenantIdentifier")
      println("processMrz: ${processMrz.toString()}")
      println("storeCapturedDocument: ${storeCapturedDocument.toString()}")
      println("performLivenessDetection: ${performLivenessDetection.toString()}")
      println("storeImageStream: ${storeImageStream.toString()}")
      println("saveCapturedVideoID: ${saveCapturedVideoID.toString()}")
      println("ENV_BRIGHTNESS_HIGH_THRESHOLD: ${ENV_BRIGHTNESS_HIGH_THRESHOLD.toString()}")
      println("ENV_BRIGHTNESS_LOW_THRESHOLD: ${ENV_BRIGHTNESS_LOW_THRESHOLD.toString()}")
      println("ENV_PREDICTION_LOW_PERCENTAGE: ${ENV_PREDICTION_LOW_PERCENTAGE.toString()}")
      println("ENV_PREDICTION_HIGH_PERCENTAGE: ${ENV_PREDICTION_HIGH_PERCENTAGE.toString()}")
      println("ENV_CustomColor: $ENV_CustomColor")
      println("ENV_HoldHandColor: $ENV_HoldHandColor")
      println("enableDetect: $enableDetect")
      println("enableGuide: $enableGuide")

       environmentalConditions =
          EnvironmentalConditions(
            enableDetect,
            enableGuide,
            ENV_BRIGHTNESS_HIGH_THRESHOLD ?: 500.0f,
            ENV_BRIGHTNESS_LOW_THRESHOLD ?: 00.0f,
            ENV_PREDICTION_LOW_PERCENTAGE ?: 50.0f,
            ENV_PREDICTION_HIGH_PERCENTAGE ?: 100.0f,
            ENV_CustomColor ?: "#f5a103",
            ENV_HoldHandColor ?: "#f5a103",
          )

      val eventResultMap = Arguments.createMap().apply {
        putBoolean("assentifySdkInitStart", true)
      }
      sendEvent("AppResult", eventResultMap)

      val sharedPreferences =
          reactApplicationContext.getSharedPreferences("BlockLoaders", Context.MODE_PRIVATE)
      val editor = sharedPreferences.edit()
      editor.putString("instanceHash", instanceHash)
      editor.apply()

      assentifySdk =
          AssentifySdk(
              apiKey,
              tenantIdentifier,
              instanceHash,
              environmentalConditions,
              this,
              processMrz,
              storeCapturedDocument,
              performLivenessDetection,
              storeImageStream,
              saveCapturedVideoID,
              saveCapturedVideoFace
          )
    } catch (e: Exception) {
      Log.e(NAME, e.toString())
    }
  }

  @ReactMethod
  fun startScanPassport(language: String,showCountDown:Boolean) {
    timeStarted = getCurrentDateTimeUTC();
    /** Nav To Passport Scan Page */
    val intent = Intent(reactApplicationContext, ScanPassportActivity::class.java)
    if (intent.resolveActivity(reactApplicationContext.packageManager) !== null) {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      intent.putExtra("holdHandColor", environmentalConditions.HoldHandColor)
      intent.putExtra("processingColor", environmentalConditions.CustomColor)
      intent.putExtra("language", language)
      intent.putExtra("showCountDown", showCountDown)
      intent.putExtra("apiKey", this.apiKey)
      reactApplicationContext?.startActivity(intent)
    }
  }

  @ReactMethod
  fun startScanOtherIDPage(language: String,showCountDown:Boolean) {
    timeStarted = getCurrentDateTimeUTC();
    /** Nav To Other Scan Page */
    val intent = Intent(currentActivity, ScanOtherActivity::class.java)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.putExtra("holdHandColor", environmentalConditions.HoldHandColor)
    intent.putExtra("processingColor", environmentalConditions.CustomColor)
    intent.putExtra("language", language)
    intent.putExtra("showCountDown", showCountDown)
    intent.putExtra("apiKey", this.apiKey)
    currentActivity?.startActivity(intent)
  }

  @ReactMethod
  fun startScanIDPage(jsonStringKycDocumentDetails: String,language: String,flippingCard:Boolean,showCountDown:Boolean) {
    timeStarted = getCurrentDateTimeUTC();
    try {
      /** Nav To ID Scan Page */
      val intent = Intent(currentActivity, ScanIDActivity::class.java)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      intent.putExtra("holdHandColor", environmentalConditions.HoldHandColor)
      intent.putExtra("processingColor", environmentalConditions.CustomColor)
      intent.putExtra("kycDocumentDetails", jsonStringKycDocumentDetails)
      intent.putExtra("language", language)
      intent.putExtra("flippingCard", flippingCard)
      intent.putExtra("title", getIdTitle(jsonStringKycDocumentDetails!!))
      intent.putExtra("showCountDown", showCountDown)
      intent.putExtra("apiKey", this.apiKey)
      currentActivity?.startActivity(intent)
    } catch (e: Exception) {
      Log.e(NAME, e.toString())
    }
  }

  //  @ReactMethod
  //  fun navigateToFaceMatch() {
  //    /**  Nav To Face Match Page **/
  //    val sharedPreferences = reactApplicationContext.getSharedPreferences("FaceMatch",
  // Context.MODE_PRIVATE)
  //    val editor = sharedPreferences.edit()
  //    editor.putString("Base64SecondImage", "+ozSHAAADAFBMVEX///...etc")
  //    editor.apply()
  //    val intent = Intent(currentActivity, FaceMatchActivity::class.java)
  //    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  //    currentActivity?.startActivity(intent)
  //  }

  override fun onAssentifySdkInitError(message: String) {
    val eventResultMap =
        Arguments.createMap().apply { putBoolean("assentifySdkInitSuccess", false) }
    sendEvent("AppResult", eventResultMap)
    showErrorMessage(message)
  }

  override fun onAssentifySdkInitSuccess(configModel: ConfigModel) {
    mainHandler.post {
      try {
        val documentCaptureStepModelPreferences =
            reactApplicationContext.getSharedPreferences(
                "DocumentCaptureStepModel",
                Context.MODE_PRIVATE
            )
        documentCaptureStepModelPreferences.edit().clear().apply()

        val sharedPreferences =
            reactApplicationContext.getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        val gson = Gson()
        val json: String = gson.toJson(configModel.stepDefinitions)
        editor.putString("Steps", json)
        editor.apply()

        /** Store React Application Context */
        AssentifySdkObject.setAssentifySdkObject(assentifySdk)
        ReactApplicationContextObject.setReactApplicationContextObject(reactApplicationContext)

        /** Send Event */
        // val eventResultMap = Arguments.createMap().apply {
        //    putBoolean("assentifySdkInitSuccess", true);
        // }
        // sendEvent("AppResult", eventResultMap)
        this.configModel = configModel;
        templatesByCountry = assentifySdk.getTemplates();

        val eventResultMap =
          Arguments.createMap().apply {
            val jsonString = encodeTemplatesByCountryToJson(templatesByCountry)
            putBoolean("assentifySdkInitSuccess", true)
            putString("AssentifySdkHasTemplates", jsonString)
          }
        sendEvent("AppResult", eventResultMap)
      } catch (e: Exception) {
        showErrorMessage(e.toString())
      }
    }
  }

  @ReactMethod
  fun submitData(data: ReadableMap? = null) {

    mainHandler.post {
      val mapData = readableMapToMap(data!!)

      val sharedDefinitions =
          reactApplicationContext.getSharedPreferences("BlockLoaders", Context.MODE_PRIVATE)
      val instanceHashStr = sharedDefinitions.getString("instanceHash", "")!!
      val previewURLStr = sharedDefinitions.getString("previewURL", "")!!

      Log.wtf("instanceHash", instanceHashStr)

      val eventResultMap =
      Arguments.createMap().apply {
        putBoolean("SubmitDataRequest", true)
        putBoolean("SubmitDataResponse", false)
        putString("instanceHash", instanceHashStr)
      }
      val result = Arguments.createMap().apply { putMap("SubmitData", eventResultMap) }
      sendEvent("EventResult", result)

      var wrapUp: SubmitRequestModel? = null
      var blockLoader: SubmitRequestModel? = null

      val sharedStepDefinitions =
          reactApplicationContext.getSharedPreferences("StepDefinitions", Context.MODE_PRIVATE)
      val gson = Gson()
      val json: String = sharedStepDefinitions.getString("Steps", "")!!
      val steps: List<StepDefinitions>? =
          gson.fromJson(json, object : TypeToken<List<StepDefinitions>>() {}.type)

      steps!!.forEach { item ->
        // ** WrapUp *//
        if (item.stepDefinition == StepsName.WrapUp) {
          val values: MutableMap<String, String> = mutableMapOf()
          item.outputProperties.forEach { property ->
            if (property.key.contains(WrapUpKeys.TimeEnded)) {
              values.put(property.key, getCurrentDateTimeUTC())
            }
          }
          wrapUp = SubmitRequestModel(item.stepId, StepsName.WrapUp, values)
        }
        // ** BlockLoader *//
        if (item.stepDefinition == StepsName.BlockLoader) {
          val values: MutableMap<String, String> = mutableMapOf()
          item.outputProperties.forEach { property ->
            if (property.key.contains(BlockLoaderKeys.TimeStarted)) {
              values.put(property.key, timeStarted)
            }
            if (property.key.contains(BlockLoaderKeys.DeviceName)) {
              values.put(property.key, "Android")
            }
            if (property.key.contains(BlockLoaderKeys.Application)) {
              values.put(property.key, configModel.instanceId)
            }
            if (property.key.contains(BlockLoaderKeys.FlowName)) {
              values.put(property.key, configModel.flowName)
            }
            if (property.key.contains(BlockLoaderKeys.UserAgent)) {
              values.put(property.key, "SDK")
            }
            if (property.key.contains(BlockLoaderKeys.InstanceHash)) {
              values.put(property.key, configModel.instanceHash)
            }
            if (property.key.contains(BlockLoaderKeys.InteractionID)) {
              values.put(property.key, configModel.instanceId)
            }
            for ((keyData, valueData) in mapData) {
              if (property.key.contains(keyData)) {
                values.put(property.key, valueData.toString())
              }
            }
          }

          blockLoader = SubmitRequestModel(item.stepId, StepsName.BlockLoader, values)
        }
      }

      // ** Doc *//
      val sharedStepDefinitionsDoc =
          reactApplicationContext.getSharedPreferences(
              "DocumentCaptureStepModel",
              Context.MODE_PRIVATE
          )
      val gsonSharedStepDefinitionsDoc = Gson()
      val jsonSharedStepDefinitionsDoc: String =
          sharedStepDefinitionsDoc.getString("DocumentCaptureStep", "")!!
      val sharedStepDefinitionsStepDoc: SubmitRequestModel =
          gsonSharedStepDefinitionsDoc.fromJson(
              jsonSharedStepDefinitionsDoc,
              object : TypeToken<SubmitRequestModel>() {}.type
          )

      // ** Face *//
      val sharedStepDefinitionsFace =
          reactApplicationContext.getSharedPreferences("FaceMatchStepModel", Context.MODE_PRIVATE)
      val gsonSharedStepDefinitionsFace = Gson()
      val jsonSharedStepDefinitionsFace: String =
          sharedStepDefinitionsFace.getString("FaceMatchStep", "")!!
      val sharedStepDefinitionsStepFace: SubmitRequestModel =
          gsonSharedStepDefinitionsFace.fromJson(
              jsonSharedStepDefinitionsFace,
              object : TypeToken<SubmitRequestModel>() {}.type
          )

      var submitRequestList: MutableList<SubmitRequestModel> = mutableListOf()
      submitRequestList.add(sharedStepDefinitionsStepDoc)
      submitRequestList.add(sharedStepDefinitionsStepFace)
      submitRequestList.add(wrapUp!!)
      submitRequestList.add(blockLoader!!)



      assentifySdk.startSubmitData(this@AssentifySdkModule, submitRequestList)
    }
  }

  /** Submit Data Functions */
  override fun onSubmitError(message: String) {
    val eventResultMap =
        Arguments.createMap().apply {
          putBoolean("SubmitDataRequest", false)
          putBoolean("SubmitDataResponse", true)
          putBoolean("success", false)
          putString("error_message", message)
        }
    val result = Arguments.createMap().apply { putMap("SubmitData", eventResultMap) }
    sendEvent("EventResult", result)
  }

  override fun onSubmitSuccess(message: String) {
    val eventResultMap = Arguments.createMap().apply {
      putBoolean("SubmitDataRequest", false)
      putBoolean("SubmitDataResponse", true)
      putBoolean("success", true)
      putString("success_message", "")
    }
    val result = Arguments.createMap().apply { putMap("SubmitData", eventResultMap) }
    sendEvent("EventResult", result)
  }

  fun getCurrentDateTimeUTC(): String {
    val currentDate = Date()

    val dateFormat = SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.getDefault())
    dateFormat.timeZone = TimeZone.getTimeZone("UTC")

    return dateFormat.format(currentDate)
  }

  @ReactMethod
  fun addListener(eventName: String) {
    // Keep: Required for RN built in Event Emitter Calls.
  }

  @ReactMethod
  fun removeListeners(count: Int) {
    // Keep: Required for RN built in Event Emitter Calls.
  }

  private fun readableMapToMap(readableMap: ReadableMap): Map<String, Any> {
    val iterator = readableMap.keySetIterator()
    val resultMap = mutableMapOf<String, Any>()

    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      when (readableMap.getType(key)) {
        ReadableType.Null -> resultMap[key] = ""
        ReadableType.Boolean -> resultMap[key] = readableMap.getBoolean(key)
        ReadableType.Number -> resultMap[key] = readableMap.getDouble(key)
        ReadableType.String -> resultMap[key] = readableMap.getString(key)!!
        ReadableType.Map -> resultMap[key] = readableMapToMap(readableMap.getMap(key)!!)
        else -> {}
      }
    }
    return resultMap
  }

  private fun getIdTitle(jsonStringKycDocumentDetails: String): String {
    var title = "";
    val gson = Gson()
    val listType = object : TypeToken<List<KycDocumentDetails>>() {}.type
    val kycDocumentDetails: List<KycDocumentDetails> =
      gson.fromJson(jsonStringKycDocumentDetails, listType)

    templatesByCountry.forEach { it ->
      it.templates.forEach { template ->
        if (template.kycDocumentDetails.isNotEmpty()) {
          if (kycDocumentDetails[0].templateProcessingKeyInformation == template.kycDocumentDetails[0].templateProcessingKeyInformation) {
            title = template.kycDocumentType;
          }
        }

      }
    }
    return title;
  }
}
