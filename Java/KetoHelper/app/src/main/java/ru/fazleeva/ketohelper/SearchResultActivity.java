package ru.fazleeva.ketohelper;

import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Bitmap;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import static ru.fazleeva.ketohelper.KetoHelperMainActivity.HTTP_REQUEST_BASE_ADDRESS;
import static ru.fazleeva.ketohelper.KetoHelperMainActivity.SHOW_SEARCH_RESULT;

public class SearchResultActivity extends AppCompatActivity {
    private WebView webView;
    private ProgressBar progressBar;
    String curPage = "default";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("KETO_SEARCH_2", "Started");

        super.onCreate(savedInstanceState);
        Log.e("KETO_SEARCH_2", "Created");
        setContentView(R.layout.activity_search_result);


        Bundle b = getIntent().getExtras();
        String value = ""; // or other values
        if(b != null) {
            value = b.getString(SHOW_SEARCH_RESULT, "").trim();
            curPage = value;
        }

//        Log.i("KETO_SEARCH_3", value);
//        Log.e("KETO_SEARCH_3", "WebView Init");
        webView = (WebView)findViewById(R.id.webViewSearchResult);
//        if(webView != null) {
//            Log.i("KETO_SEARCH__", "is Valid");
//        }
//        else {
//            Log.i("KETO_SEARCH__", "is NULL");
//        }

        webView.setWebViewClient(new myWebClient());
//        Log.i("KETO_SEARCH_4", "again");
        webView.getSettings().setJavaScriptEnabled(true);


        // удалить в продакшн версии!
        webView.getSettings().setAppCacheEnabled(false);
        webView.clearCache(true);
        webView.loadUrl("about:blank");
        webView.reload();
        // до сих пор
        progressBar = (ProgressBar) findViewById(R.id.progressBarSearchResult);
        // указываем страницу загрузки
        //webView.loadUrl(HTTP_REQUEST_BASE_ADDRESS + "wiki/?article=" + value);
        webView.loadUrl(HTTP_REQUEST_BASE_ADDRESS + "?article=" + value);
        //Log.i("KETO_URL", HTTP_REQUEST_BASE_ADDRESS + "?article=" + value);
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

            //view.saveWebArchive(getApplicationInfo().dataDir + "/" + curPage + ".html");
            //Log.i("KETO_URL", "saved to " + getApplicationInfo().dataDir + "/" + curPage + ".html");
        }

        @RequiresApi(api = Build.VERSION_CODES.M)
        @Override
        public void onReceivedError (WebView view, WebResourceRequest request, WebResourceError error) {
//            Log.i("WEB_VIEW_TEST1", "error code: " + error.getDescription());
            super.onReceivedError(view, error.getErrorCode(), "Что-то пошло не так...", "");
            String unencodedHtml = "<html><body><div style=\"text-align:center;display:flex;width:100vw;height:100vh;justify-content:center;align-items:center;font-size:23px;\"><p>Ой... Похоже, Интернета нет... Жалость какая. :(</p></div></body></html>";
            String encodedHtml = Base64.encodeToString(unencodedHtml.getBytes(), Base64.NO_PADDING);
            webView.loadData(encodedHtml, "text/html", "base64");
        }

        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
//            Log.i("WEB_VIEW_TEST2", "error code: " + errorCode);
            super.onReceivedError(view, errorCode, "Что-то пошло не так...", "");
            String unencodedHtml = "<html><body><div style=\"text-align:center;display:flex;width:100vw;height:100vh;justify-content:center;align-items:center;font-size:23px;\"><p>Ой... Похоже, Интернет «всё»... Жалость какая. :(</p></div></body></html>";
            String encodedHtml = Base64.encodeToString(unencodedHtml.getBytes(), Base64.NO_PADDING);
            webView.loadData(encodedHtml, "text/html", "base64");
        }
    }
}