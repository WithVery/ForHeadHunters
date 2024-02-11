package ru.fazleeva.ketohelper;

import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.ConsoleMessage;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import static ru.fazleeva.ketohelper.KetoHelperMainActivity.HTTP_REQUEST_BASE_ADDRESS;
import static ru.fazleeva.ketohelper.KetoHelperMainActivity.SHOW_SEARCH_RESULT;

public class OurServicesActivity extends AppCompatActivity {

    private WebView webView;
    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_our_services);


        Bundle b = getIntent().getExtras();
        String value = ""; // or other values
        if(b != null)
            value = b.getString(SHOW_SEARCH_RESULT, "");

        webView = (WebView)findViewById(R.id.webViewOurServices);
        if(webView != null) {
            Log.i("KETO_SEARCH_!", "is Valid");
        }
        else {
            Log.i("KETO_SEARCH_!", "is NULL");
        }

/*
        webView.setWebViewClient(new myWebClient());
        webView.getSettings().setJavaScriptEnabled(true);

        // удалить в продакшн версии!
        webView.getSettings().setAppCacheEnabled(false);
        webView.clearCache(true);
        webView.loadUrl("about:blank");
        webView.reload();
        // до сих пор

        progressBar = (ProgressBar) findViewById(R.id.progressBarOurServices);
        // указываем страницу загрузки
        webView.loadUrl(value);
*/

        webView.setWebChromeClient(new myChromeClient());
        webView.setWebViewClient(new myWebClient());
        webView.getSettings().setJavaScriptEnabled(true);

        // удалить в продакшн версии!
        webView.getSettings().setAppCacheEnabled(false);
        webView.clearCache(true);
        webView.getSettings().setAppCacheEnabled(true);
        webView.loadUrl("about:blank");
        webView.reload();
        // до сих пор
        progressBar = (ProgressBar) findViewById(R.id.progressBarOurServices);

        webView.loadUrl(value);

    }

    public class myChromeClient extends WebChromeClient {
        @Override
        public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
            Log.d("KetoHelper", consoleMessage.message() + " -- From line " +
                    consoleMessage.lineNumber() + " of " + consoleMessage.sourceId());
            return true;
        }
    }

    public class myWebClient extends WebViewClient {
        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            // TODO Auto-generated method stub
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            progressBar.setVisibility(View.VISIBLE);
            view.loadUrl(url);
            return true;
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            progressBar.setVisibility(View.GONE);
        }

        @RequiresApi(api = Build.VERSION_CODES.M)
        @Override
        public void onReceivedError (WebView view, WebResourceRequest request, WebResourceError error) {
            Log.i("WEB_VIEW_TEST1", "error code: " + error.getDescription());
            super.onReceivedError(view, error.getErrorCode(), "Что-то пошло не так...", "");
            view.loadUrl("about:blank");
        }

        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            Log.i("WEB_VIEW_TEST2", "error code: " + errorCode);
            super.onReceivedError(view, errorCode, "Что-то пошло не так...", "");
            view.loadUrl("about:blank");
        }
    }

}
