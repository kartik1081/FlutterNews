package com.example.mvvm_plugin;

import static android.Manifest.permission.READ_PHONE_NUMBERS;
import static android.Manifest.permission.READ_PHONE_STATE;
import static android.Manifest.permission.READ_SMS;
import static android.content.Context.KEYGUARD_SERVICE;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.DownloadManager;
import android.app.KeyguardManager;
import android.content.DialogInterface;
import android.hardware.biometrics.BiometricPrompt;
import android.os.Environment;
import android.os.Handler;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.IconCompat;


import java.util.HashMap;
import java.util.concurrent.Executor;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.os.CancellationSignal;

/** MvvmPlugin */
public class MvvmPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private Activity activity;

  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "mvvm_plugin");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
  }

  @RequiresApi(api = Build.VERSION_CODES.P)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + Build.VERSION.RELEASE);
        break;
      case "showToast": {
        String argument = call.argument("toast");
        Toast.makeText(context, argument, Toast.LENGTH_SHORT).show();
        break;
      }
      case "checkConnectivity":
        result.success(checkConnection(context));
        break;
      case "pushNotification": {
        HashMap<String, String> argument = (HashMap<String, String>) call.arguments;
        pushNotification(argument);
        break;
      }
      case "openBrowser":
        String url = call.argument("url");
        openBrowser(result, url);
        break;
      case "makePayment":
        String upiLink = call.argument("upiLink");
        makePayment(upiLink);
        break;
      case "openCamera":
        openCamera();
        break;
      case "getContacts":
        break;
      case "telephoneDetail":
        getTelePhoneDetails();
        break;
      case "download":
        if (checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
          String link = call.argument("link");
          downloads(link);
        } else {
          ActivityCompat.requestPermissions(this.activity, new String[] { Manifest.permission.WRITE_EXTERNAL_STORAGE },
              2);
        }
        break;
      case "biometricAuth":
        if (!keyguardSecure()) {
          Toast.makeText(context, "Lock screen security not enabled in Settings", Toast.LENGTH_SHORT).show();
        }
        if (checkPermission(Manifest.permission.USE_BIOMETRIC)) {
          biometricAuth(result);
        } else {
          ActivityCompat.requestPermissions(this.activity, new String[] { Manifest.permission.USE_BIOMETRIC }, 3);
          Toast.makeText(context, "Required permission for biometric authentication", Toast.LENGTH_SHORT).show();
        }
        break;
      case "checkBiometric":
        result.success(keyguardSecure());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
  }

  private void makePayment(String url) {
    Intent upiPayIntent = new Intent(Intent.ACTION_VIEW);
    upiPayIntent.setData(Uri.parse(url));
    Intent chooser = Intent.createChooser(upiPayIntent, "Pay with");
    if (null != chooser.resolveActivity(this.context.getPackageManager())) {
      activity.startActivityForResult(chooser, 4);
    } else {
      Toast.makeText(this.context, "No UPI app found, please install one to continue", Toast.LENGTH_SHORT).show();
    }
  }

  @SuppressLint("HardwareIds")
  private void getTelePhoneDetails(){

    TelephonyManager telephoneManager = (TelephonyManager) this.context.getSystemService(Context.TELEPHONY_SERVICE);
    if(checkPermission(READ_SMS)){
      if(checkPermission(READ_PHONE_NUMBERS)){
        if(checkPermission(READ_PHONE_STATE)){
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Log.d("telephone", "getTelePhoneDetails: True");
            Toast.makeText(context, telephoneManager.getLine1Number(), Toast.LENGTH_SHORT).show();
          }
        }else{
          ActivityCompat.requestPermissions(this.activity, new String[] { READ_PHONE_STATE }, 7);

        }
      }else {
        ActivityCompat.requestPermissions(this.activity, new String[] { READ_SMS }, 6);
      }
    }else{
      ActivityCompat.requestPermissions(this.activity, new String[] { READ_SMS }, 5);
    }
  }

  private void biometricAuth(@NonNull Result result) {
    BiometricPrompt biometricPrompt;
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
      biometricPrompt = new BiometricPrompt.Builder(this.context)
          .setTitle("Unlock MVVM")
          .setSubtitle("Authentication is required to continue")
          .setDescription("This app uses biometric authentication to protect your data.")
          .setNegativeButton("Cancel", executor,
                  (dialogInterface, i) -> {
                    Toast.makeText(context, "Authentication cancelled", Toast.LENGTH_SHORT).show();
                    result.success(false);
                  })
          .build();

      biometricPrompt.authenticate(getCancellationSignal(), executor,
          getAuthenticationCallback(result));
    }
  }

  private boolean keyguardSecure(){
    KeyguardManager keyguardManager = (KeyguardManager) this.context.getSystemService(KEYGUARD_SERVICE);
    Log.d("keyGuard", "keyguardSecure: True");
    return keyguardManager.isKeyguardSecure();
  }

  private BiometricPrompt.AuthenticationCallback getAuthenticationCallback(@NonNull Result r) {

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
      return new BiometricPrompt.AuthenticationCallback() {
        @Override
        public void onAuthenticationError(int errorCode, CharSequence errString) {
          super.onAuthenticationError(errorCode, errString);
        }

        @Override
        public void onAuthenticationHelp(int helpCode, CharSequence helpString) {
          super.onAuthenticationHelp(helpCode, helpString);
        }

        @Override
        public void onAuthenticationFailed() {
          super.onAuthenticationFailed();
          Toast.makeText(context, "Authentication failed", Toast.LENGTH_SHORT).show();
          r.success(false);
        }

        @Override
        public void onAuthenticationSucceeded(
            BiometricPrompt.AuthenticationResult result) {
          super.onAuthenticationSucceeded(result);
          Toast.makeText(context, "Authentication successful", Toast.LENGTH_SHORT).show();
          r.success(true);
        }
      };
    }
    return null;
  }

  private CancellationSignal getCancellationSignal() {

    CancellationSignal cancellationSignal = new CancellationSignal();
    cancellationSignal.setOnCancelListener(() -> Toast.makeText(context, "Cancelled via signal", Toast.LENGTH_SHORT).show());
    return cancellationSignal;
  }

  private final Handler handler = new Handler();

  private final Executor executor = handler::post;

  private void downloads(String link) {
    DownloadManager downloadManager = (DownloadManager) this.context.getSystemService(Context.DOWNLOAD_SERVICE);
    Uri uri = Uri.parse(link);
    DownloadManager.Request request = new DownloadManager.Request(uri);
    request.setTitle("My File");
    request.setDescription("Downloading");
    request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
    request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, uri.getLastPathSegment());
    // request.setDestinationUri(Uri.parse("file://" + folderName + "/myfile.mp3"));
    downloadManager.enqueue(request);
  }

  private boolean checkConnection(Context context) {
    ConnectivityManager connectivityManager = (ConnectivityManager) context
        .getSystemService(Context.CONNECTIVITY_SERVICE);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      return connectivityManager.getActiveNetwork() != null;
    } else {
      return connectivityManager.getActiveNetworkInfo().isConnected();
    }
  }

  private void pushNotification(HashMap<String, String> data) {
    NotificationChannel notificationChannel;
    NotificationCompat.Builder builder;
    String description = "Test notification";
    String channelId = data.get("id");
    String title = data.get("author");
    String body = data.get("title");
    String smallIcon = data.get("imageUrl");
    NotificationManager notificationManager = (NotificationManager) this.context
        .getSystemService(Context.NOTIFICATION_SERVICE);
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
      notificationChannel = new NotificationChannel(channelId, description, NotificationManager.IMPORTANCE_HIGH);
      notificationChannel.enableLights(true);
      notificationChannel.enableVibration(true);
      notificationManager.createNotificationChannel(notificationChannel);

      assert channelId != null;
      assert smallIcon != null;
      builder = new NotificationCompat.Builder(this.context, channelId)
          .setSmallIcon(IconCompat.createWithContentUri(smallIcon))
          .setContentTitle(title)
          .setContentText(body)
          .setSmallIcon(IconCompat.createWithContentUri(smallIcon));
    } else {
      assert channelId != null;
      builder = new NotificationCompat.Builder(this.context, channelId)
          // .setSmallIcon(IconCompat.createWithContentUri("https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"))
          .setContentTitle(title)
          .setContentText(body)
          .setLargeIcon(BitmapFactory.decodeFile(smallIcon));
    }
    notificationManager.notify(1234, builder.build());
  }

  private void openBrowser(Result result, String url) {
    if (activity == null) {
      result.error("ACTIVITY_NOT_AVAILABLE",
          "Browser cannot be opened without foreground activity", null);
      return;
    }
    Intent intent = new Intent(Intent.ACTION_VIEW);
    intent.setData(Uri.parse(url));
    activity.startActivity(intent);
    result.success((Object) true);
  }

  private void openCamera() {
    if (checkPermission(Manifest.permission.CAMERA)) {
      Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
      activity.startActivityForResult(intent, 101);
    } else {
      ActivityCompat.requestPermissions(this.activity, new String[] { Manifest.permission.CAMERA }, 1);
    }
  }

  private boolean checkPermission(String permission) {
    return ContextCompat.checkSelfPermission(this.context, permission) == PackageManager.PERMISSION_GRANTED;
  }

  // @SuppressLint("Range")
  // private ArrayList getContacts(){
  // ArrayList<String> list = new ArrayList<>();
  // cur = contentResolver.query(ContactsContract.Contacts.CONTENT_URI,null,
  // null,null,null);
  // if ((cur != null ? cur.getCount() : 0) > 0) {
  // while (cur.moveToNext()) {
  // String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));
  // String name =
  // cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
  // list.add(name);
  // if (cur.getInt(cur.getColumnIndex(
  // ContactsContract.Contacts.HAS_PHONE_NUMBER)) > 0) {
  // Cursor pCur = contentResolver.query(
  // ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
  // null,
  // ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?",
  // new String[]{id}, null);
  // while (pCur.moveToNext()) {
  // String phoneNo =
  // pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
  // Log.d("phoneNumber", "getContacts: "+phoneNo);
  // }
  // pCur.close();
  // }
  // }
  // }
  // return list;
  // }
}
