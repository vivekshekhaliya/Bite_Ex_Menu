package com.example.menu

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log

class ForegroundService : Service() {

    private val CHANNEL_ID = "kiosk_service_channel"

    override fun onCreate() {
        super.onCreate()
        try {
            createNotificationChannel()
            val notification = buildNotification()
            startForeground(1, notification)
            Log.d("ForegroundService", "Service successfully started and put in foreground")
        } catch (e: Exception) {
            Log.e("ForegroundService", "Error in onCreate", e)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("ForegroundService", "Foreground service is running")
        // Return START_STICKY to ensure the service is restarted if killed by the OS
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null // No binding required for this service
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.e("ForegroundService", "App removed from memory/killed. Attempting to relaunch...")
        try {
            val restartIntent = Intent(applicationContext, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            }
            startActivity(restartIntent)
        } catch (e: Exception) {
            Log.e("ForegroundService", "Error relaunching app from onTaskRemoved", e)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Kiosk Persistent Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Keeps the menu app running in the background."
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }

    private fun buildNotification(): Notification {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Menu Display Active")
                .setContentText("Preventing system from closing the app")
                .setSmallIcon(android.R.drawable.btn_star) // using a built-in icon
                .build()
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
                .setContentTitle("Menu Display Active")
                .setContentText("Preventing system from closing the app")
                .setSmallIcon(android.R.drawable.btn_star)
                .build()
        }
    }
}
