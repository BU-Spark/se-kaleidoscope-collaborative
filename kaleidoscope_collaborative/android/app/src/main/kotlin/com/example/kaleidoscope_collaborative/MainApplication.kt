package com.example.kaleidoscope_collaborative

import io.flutter.app.FlutterApplication
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger

class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        // Initialize Facebook SDK
        FacebookSdk.sdkInitialize(applicationContext)
        AppEventsLogger.activateApp(this)
    }
}

