package com.example.magnetometer_compass

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val channelName = "magnetometer"
    private lateinit var sensorManager: SensorManager
    private var magnetometer: Sensor? = null
    private val sensorDelay = SensorManager.SENSOR_DELAY_FASTEST
    private val magneticValues = FloatArray(3)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        channel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "testing") {
                Toast.makeText(this, "Testing", Toast.LENGTH_LONG).show()
                result.success(0)
            } else if (call.method == "streamMagnetometer") {
                startMagnetometerStream()
                result.success(null)
            }
            if(call.method=="dispose"){
                onDestroy();
            }
        }
    }

    private fun startMagnetometerStream() {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        if (magnetometer != null) {
            sensorManager.registerListener(this, magnetometer, sensorDelay)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Do something when sensor accuracy changes.
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event!!.sensor == magnetometer) {
            magneticValues[0] = event.values[0]
            magneticValues[1] = event.values[1]
            magneticValues[2] = event.values[2]
            val channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channelName)
            channel.invokeMethod("magnetometerData", magneticValues)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
    }
}
