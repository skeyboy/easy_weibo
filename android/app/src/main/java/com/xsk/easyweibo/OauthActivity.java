package com.xsk.easyweibo;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.JsonReader;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;

import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;

public class OauthActivity extends Activity {
    private static final String redirect_uri = "https://api.weibo.com/oauth2/default.html";
    private static final String url = "https://api.weibo.com/oauth2/authorize?client_id=4049546345&redirect_uri=" + redirect_uri + "&response_type=code";
    WebView webView;
    private ProgressBar progressBar;
    OkHttpClient okHttpClient = new OkHttpClient();

    private String accessToken;
    private String refreshToken;
    private String expires;
    private String userId;
    private String code;

    private WebViewClient webViewClient = new WebViewClient() {
        @Override
        public void onPageFinished(WebView view, String url) {//页面加载完成
            progressBar.setVisibility(View.GONE);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {//页面开始加载
            progressBar.setVisibility(View.VISIBLE);
            Log.i("start", url);

        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            Log.i("ansen", "拦截url:" + url);
            if (url.startsWith(redirect_uri)) {
                //拦截掉 code的生成显示UI


                if (url.startsWith(redirect_uri)) {
                    code = url.split("code=")[1];//https://api.weibo.com/oauth2/default.html?code=d2f75ca82e12c3678db75faf5178fc4e
                    FormBody.Builder builder = new FormBody.Builder();
                    builder.add("client_id", "4049546345");
                    builder.add("client_secret", "f2b030d13ec05f460b74e62f46144f40");
                    builder.add("grant_type", "authorization_code");
                    builder.add("redirect_uri", redirect_uri);
                    builder.add("code", code);
                    Request request = new Request.Builder()
                            .url("https://api.weibo.com/oauth2/access_token")
                            .post(builder.build())
                            .build();

                    okHttpClient.newCall(request).enqueue(new okhttp3.Callback() {
                        @Override
                        public void onFailure(okhttp3.Call call, IOException e) {
                            Log.e("token Error", e.toString());
                        }

                        @Override
                        public void onResponse(okhttp3.Call call, okhttp3.Response response) throws IOException {
                            String json = response.body().string();
                            Log.i("token", json);
                            Intent intent = new Intent(OauthActivity.this, MainActivity.class);

                            intent.putExtra("token", json);
                            startActivity(intent);

                        }
                    });


                }

                return true;
            }
            if (url.equals("http://www.google.com/")) {
                Toast.makeText(OauthActivity.this, "国内不能访问google,拦截该url", Toast.LENGTH_LONG).show();
                return true;//表示我已经处理过了
            }
            return super.shouldOverrideUrlLoading(view, url);
        }

    };

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (webView.canGoBack() && keyCode == KeyEvent.KEYCODE_BACK) {
            webView.goBack();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_oauth);


        webView = findViewById(R.id.webView);
        progressBar = (ProgressBar) findViewById(R.id.progressbar);//进度条


        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setSupportZoom(true);
        settings.setBuiltInZoomControls(true);
        settings.setSavePassword(false);
        settings.setSaveFormData(false);

        webView.requestFocusFromTouch();

        webView.setWebViewClient(webViewClient);
        webView.loadUrl(url);
        Map<String, String> headers = new HashMap<>();
        headers.put("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0) Gecko/20100101 Firefox/64.0");
        webView.loadUrl(url, headers);

    }
}

