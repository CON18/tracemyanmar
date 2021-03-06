package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin());
      com.notrait.deviceid.DeviceIdPlugin.registerWith(shimPluginRegistry.registrarFor("com.notrait.deviceid.DeviceIdPlugin"));
      com.example.devicelocale.DevicelocalePlugin.registerWith(shimPluginRegistry.registrarFor("com.example.devicelocale.DevicelocalePlugin"));
      io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin"));
      io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    flutterEngine.getPlugins().add(new com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin());
    flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
      co.sunnyapp.flutter_phone_state.FlutterPhoneStatePlugin.registerWith(shimPluginRegistry.registrarFor("co.sunnyapp.flutter_phone_state.FlutterPhoneStatePlugin"));
      io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
      io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin.registerWith(shimPluginRegistry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
      com.baseflow.geolocator.GeolocatorPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
    flutterEngine.getPlugins().add(new com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.googlemaps.GoogleMapsPlugin());
      com.baseflow.location_permissions.LocationPermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.urllauncher.UrlLauncherPlugin());
  }
}
