package ru.fazleeva.ketohelper;

import android.app.LoaderManager;
import android.app.LoaderManager.LoaderCallbacks;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.Loader;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.provider.BaseColumns;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FilterQueryProvider;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class KetoHelperMainActivity extends AppCompatActivity implements
        SharedPreferences.OnSharedPreferenceChangeListener {
    //public static final String EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE";
    public static final String LOG_TAG = KetoHelperMainActivity.class.getName();
    public static final String SHOW_SEARCH_RESULT = "ru.fazleeva.ketohelper.SHOW_SEARCH_RESULT";
    //public static final String HTTP_REQUEST_BASE_ADDRESS = "http://192.168.1.65/";
    public static final String HTTP_REQUEST_BASE_ADDRESS = "https://data.fpsoft.ru/ketowiki/";
    public static final String HTTP_INTENSIVE_WEB_LINMK = "https://fazleeva.ru/ketointensive/";
    public static final String HTTP_OUR_SERVICES_WEB_LINMK = "https://fazleeva.ru/%d0%b8%d0%bd%d0%b4%d0%b8%d0%b2%d0%b8%d0%b4%d1%83%d0%b0%d0%bb%d1%8c%d0%bd%d1%8b%d0%b5-%d0%ba%d0%be%d0%bd%d1%81%d1%83%d0%bb%d1%8c%d1%82%d0%b0%d1%86%d0%b8%d0%b8/";
    public static final String HTTP_WEB_SHOP_WEB_LINMK = "https://fazleeva.ru/downloadmaterials-page/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button searchProductButton = (Button)findViewById(R.id.btnSearchProduct);

        // set listener to SendEMailButton
        FloatingActionButton sendButton=(FloatingActionButton)findViewById(R.id.send_email_button);
        sendButton.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(Intent.ACTION_SENDTO);
                intent.setData(Uri.parse("mailto:support@fazleeva.ru")); // only email apps should handle this
                intent.putExtra(Intent.EXTRA_SUBJECT, "Нужна помощь");
                if (intent.resolveActivity(getPackageManager()) != null) {
//                    Log.i("KETO", "Sending...");
                    startActivity(intent);
                }
                else {
//                    Log.i("KETO", "Failed to resolve email sender!");
                    //Toast.makeText(getActivity(), "Не удалось отправить сообщение.", Toast.LENGTH_LONG).show();
                }
            }
        });

        AutoCompleteTextView autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.autocomplete);

        autoCompleteTextView.setThreshold(1);
        autoCompleteTextView.setDropDownVerticalOffset(10);
        String[] from = { "name", "description" };
        int[] to = { android.R.id.text1, android.R.id.text2 };
        SimpleCursorAdapter a = new SimpleCursorAdapter(this, android.R.layout.simple_list_item_2, null, from, to, 0);
        a.setStringConversionColumn(1);
        FilterQueryProvider provider = new FilterQueryProvider() {
            @Override
            public Cursor runQuery(CharSequence constraint) {
                // run in the background thread
//                Log.d("runQuery", "runQuery constraint: " + constraint);
                if (constraint == null) {
                    return null;
                }
                String[] columnNames = { BaseColumns._ID, "name", "description" };
                MatrixCursor c = new MatrixCursor(columnNames);
                try {

                    String sConstraint = constraint.toString();
                    //String urlString = "http://192.168.1.11/api.php?" +
                    String urlString = HTTP_REQUEST_BASE_ADDRESS + "api.php?" +
                            //"action=opensearch&search=" + String(constraint).trim() +
                            "action=opensearch&search=" + sConstraint.trim() +
                            "&limit=8&namespace=0&format=json";
                    //Log.i("KETO_URL", urlString);


                    URL url = new URL(urlString);
                    InputStream stream = url.openStream();
                    BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
                    String jsonStr = reader.readLine();
                    // output ["query", ["n0", "n1", ..], ["d0", "d1", ..]]
                    JSONArray json = new JSONArray(jsonStr);
                    JSONArray names = json.getJSONArray(1);
                    JSONArray descriptions = json.getJSONArray(2);
                    for (int i = 0; i < names.length(); i++) {
                        c.newRow().add(i).add(names.getString(i)).add(descriptions.getString(i));
                    }
                } catch (Exception e) {
                    //Toast toast = Toast.makeText(getApplicationContext(), "Oops", Toast.LENGTH_SHORT);
                    //toast.show();
                    e.printStackTrace();
                }
                return c;
            }
        };
        a.setFilterQueryProvider(provider);
        autoCompleteTextView.setAdapter(a);

        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Cursor cursor = (Cursor) parent.getItemAtPosition(position);
                int nc = cursor.getColumnCount();
                String keyword = cursor.getString(1);
                String s0 = cursor.getString(0);
/*
                Toast toast = Toast.makeText(getApplicationContext(), s0 + " : " + keyword, Toast.LENGTH_SHORT);
                toast.show();
                Toast toast = Toast.makeText(getApplicationContext(), keyword, Toast.LENGTH_SHORT);
                toast.show();
*/
                showSearchResultWebPage(keyword);
            }
        });
        // load search history
        List<String> searchedHistoryList = new ArrayList<String>();

        SharedPreferences prefs = getPreferences(Context.MODE_PRIVATE);
        for(int i = 0; i < 10; i++) {
            String sn = "search" + i;
            String searchTitle = prefs.getString(sn, "");
            if(!searchTitle.isEmpty()) {
                //Log.i("KETO", "_" + sn + " : " + searchTitle);
                searchedHistoryList.add(searchTitle);
            }
        }

        // populating history list
        ListView listView = findViewById(R.id.listHistory);

        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,
                android.R.layout.simple_list_item_1, searchedHistoryList);

        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String keyword = (String) parent.getItemAtPosition(position);
                showSearchResultWebPage(keyword);
            }
        });

    }

    public void openMainWebSitePage(String address) {
        Intent intent = new Intent(this, OurServicesActivity.class);
        if(!address.isEmpty()) {
            intent.putExtra(SHOW_SEARCH_RESULT, address);
            startActivity(intent);
        }
    }

    public void showSearchResultWebPage(String keyword1) {
        //Intent intent = new Intent(this, OurServicesActivity.class);
        //Log.i("KETO_SEARCH_", keyword);
        String keyword = keyword1.trim();
        Intent intent = new Intent(this, SearchResultActivity.class);

        if(!keyword.isEmpty()) {
//            Log.i("KETO_SEARCH", keyword);
            List<String> listHist = new ArrayList<String>();
            listHist.add(keyword);
            SharedPreferences prefs = getPreferences(Context.MODE_PRIVATE);
            for(int i = 0; i < 10; i++) {
                String sc = "search" + (i);
                String sv = prefs.getString(sc, "");
                boolean bFound = false;
                for(int j = 0; !bFound && (j < listHist.size()); j++) {
                    bFound = sv.equals(listHist.get(j));
                }
                if(!bFound) {
                    listHist.add(sv.trim());
                }
            }

            SharedPreferences.Editor editor = prefs.edit();
            //editor.putString("search0", keyword);
            for(int i = 0; i < 10; i++) {
                String sv = i < listHist.size() ? listHist.get(i) : "";
                String sc = "search" + i;
                editor.putString(sc, sv);
            }
            editor.apply();

            //Log.i("KETO",  "_search1 : " + keyword);

            intent.putExtra(SHOW_SEARCH_RESULT, keyword);
            startActivity(intent);
        }
    }

    public void showProdSearchResult(View view) {
        AutoCompleteTextView autoCompleteTextView = (AutoCompleteTextView) findViewById(R.id.autocomplete);
        String keyword = autoCompleteTextView.getText().toString();
        showSearchResultWebPage(keyword);
    }

    public void showOurServicesWebPage() {
//        Log.i("KETO", "Starting `Our services` Activity...");
        Intent launchNewIntent = new Intent(this, OurServicesActivity.class);
        startActivityForResult(launchNewIntent, 0);
    }

    public void showAboutAppPage() {
//        Log.i("KETO", "Starting `Our services` Activity...");
        Intent launchNewIntent = new Intent(this, AboutAppActivity.class);
        startActivityForResult(launchNewIntent, 0);
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.our_services:
                openMainWebSitePage(HTTP_OUR_SERVICES_WEB_LINMK);
                return true;
            case R.id.intensive:
                openMainWebSitePage(HTTP_INTENSIVE_WEB_LINMK);
                return true;
            case R.id.shop:
                openMainWebSitePage(HTTP_WEB_SHOP_WEB_LINMK);
                return true;
            case R.id.about_app: {
                showAboutAppPage();
                return true;
            }
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences prefs, String key) {
/*
        if (key.equals(getString(R.string.settings_min_magnitude_key)) ||
                key.equals(getString(R.string.settings_order_by_key))){
            // Clear the ListView as a new query will be kicked off
            mAdapter.clear();

            // Hide the empty state text view as the loading indicator will be displayed
            mEmptyStateTextView.setVisibility(View.GONE);

            // Show the loading indicator while new data is being fetched
            View loadingIndicator = findViewById(R.id.loading_indicator);
            loadingIndicator.setVisibility(View.VISIBLE);

            // Restart the loader to requery the USGS as the query settings have been updated
            getLoaderManager().restartLoader(EARTHQUAKE_LOADER_ID, null, this);
        }
*/
    }

    public static class EarthquakePreferenceFragment extends PreferenceFragment {

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

}