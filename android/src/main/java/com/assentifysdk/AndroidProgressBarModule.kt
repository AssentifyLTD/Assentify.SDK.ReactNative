package com.assentifysdk

import android.R
import android.widget.ProgressBar
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp


class AndroidProgressBarModule : SimpleViewManager<ProgressBar?>() {
  var videoView: ProgressBar? = null
  override fun getName(): String {
    return REACT_CLASS
  }

  override fun createViewInstance(reactContext: ThemedReactContext): ProgressBar {
    videoView = ProgressBar(reactContext, null, R.attr.progressBarStyleHorizontal)
    return videoView as ProgressBar
  }

  @ReactProp(name = "max")
  fun setMax(view: ProgressBar, progress: Int) {
    view.max = progress
  }

  @ReactProp(name = "progress")
  fun setProgress(view: ProgressBar, progress: Int) {
    view.progress = progress
  }

  companion object {
    const val REACT_CLASS = "AndroidProgressBarModule"
  }
}
