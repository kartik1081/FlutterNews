package com.example.mvvm

import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.core.app.NotificationCompat
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import android.content.ContentResolver;
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Bundle


class MainActivity: FlutterActivity() {
    private val CHANNEL = "toast.flutter.io/toast";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
             if(call.method == "pushNotification"){
                val argument = call.arguments as java.util.HashMap<String, String>;
                pushNotification(this,argument);
             }
            else{
                result.notImplemented();
            }
        }
    }

    private fun pushNotification(context: Context,hashData: HashMap<String, String>){
        var completed = false
        lateinit var notificationChannel: NotificationChannel
        lateinit var builder: NotificationCompat.Builder
        val channelId = "i.apps.notifications"
        val description = "Test notification"
        // val id = hashData["id"];
        val title = hashData["title"];
        val body = hashData["body"];
        val priority = NotificationManager.IMPORTANCE_HIGH;

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = NotificationChannel(channelId, description,priority)
            notificationChannel.enableLights(true)
            notificationChannel.enableVibration(false)
            notificationManager.createNotificationChannel(notificationChannel)

//            builder = Notifica
            builder = NotificationCompat.Builder(this, channelId)
                .setSmallIcon(R.drawable.launch_background)
                .setAutoCancel(true)
                .setContentTitle(title)
                .setContentText(body)
                // .setContentIntent(completed = true)
                // .setStyle(new Notification.BigTextStyle()
                //     .bigText(aVeryLongString))
        }
        else{
            builder = NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.launch_background)
                .setAutoCancel(true)
                .setContentTitle(title)
                .setContentText(body)
                // .setStyle(new Notification.BigTextStyle()
                //     .bigText(aVeryLongString))
        }
        notificationManager.notify(1234,builder.build())

    }

}
    