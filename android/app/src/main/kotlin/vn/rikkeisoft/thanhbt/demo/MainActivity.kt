package vn.rikkeisoft.thanhbt.demo

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Handler
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(),EventChannel.StreamHandler {
    private val methodChannel = "os_method"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getOsVersion") {
                getOsVersions(result)
            } else {
                result.notImplemented()
            }
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(this)
    }

    private fun getOsVersions(result: MethodChannel.Result) {
        val version = Build.VERSION.RELEASE
        result.success(version)
    }

    private val eventChannel = "os_event"
    private var sink : EventChannel.EventSink? = null
    private var handle : Handler? = null
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)

    private  val runnable = Runnable {
        getConnectionType()
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private  fun getConnectionType() {
        var type = "disconnect"
        val connectionTivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager?
        if (connectionTivityManager != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            val capabilities =
                connectionTivityManager.getNetworkCapabilities(connectionTivityManager.activeNetwork)
            if (capabilities != null) {
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                    type = "mobile"
                }
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI_AWARE)){
                    type = "wifi"
                }
            }
            sink?.success(type)
            handle?.postDelayed(runnable,1000)

        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        handle = Handler()
        handle?.postDelayed(runnable,1000)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCancel(arguments: Any?) {
        sink =null
        handle?.removeCallbacks(runnable)
    }
}
