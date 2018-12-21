package com.xsk.easyweibo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.alibaba.fastjson.JSON;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    final int Token_Request = 100;
    String token;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        EventChannel eventChannel = new EventChannel(getFlutterView(), "App/Event/token");
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                     Intent intent = getIntent();
                    String jsonToken = intent.getStringExtra("token");

                eventSink.success(JSON.parse(jsonToken));
             }

            @Override
            public void onCancel(Object o) {

            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();

    }
}
