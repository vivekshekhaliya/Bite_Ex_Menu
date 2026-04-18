package com.example.menu

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    private val heartbeatHandler = Handler(Looper.getMainLooper())
    private val heartbeatRunnable = object : Runnable {
        override fun run() {
            Log.d("MainActivity", "Heartbeat tick - keeping main thread active")
            // Schedule next tick in 30 seconds
            heartbeatHandler.postDelayed(this, 30000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        try {
            // Keep screen on continuously
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            Log.d("MainActivity", "Added FLAG_KEEP_SCREEN_ON")

            // Start Foreground Service
            val serviceIntent = Intent(this, ForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
            } else {
                startService(serviceIntent)
            }
            
            // Enable Kiosk Mode (Lock Task Mode)
            try {
                startLockTask()
                Log.d("MainActivity", "Started LockTask mode successfully")
            } catch (e: Exception) {
                Log.e("MainActivity", "Could not start LockTask mode. Will continue without it.", e)
            }

            // Start heartbeat periodically
            heartbeatHandler.post(heartbeatRunnable)
            
        } catch (e: Exception) {
            Log.e("MainActivity", "Error during onCreate execution", e)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        heartbeatHandler.removeCallbacks(heartbeatRunnable)
    }

    @Suppress("DEPRECATION")
    override fun onBackPressed() {
        // Do nothing to prevent exiting the app using the back button
        Log.d("MainActivity", "Back button pressed - intercepted to keep app in foreground")
    }
}
