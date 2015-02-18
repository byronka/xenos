package com.renomad.xenos.tests;

import java.nio.charset.StandardCharsets;
import java.net.HttpURLConnection;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.PrintStream;
import java.net.URL;
import java.net.Socket;

import java.util.List;
import java.util.ArrayList;

import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.http.impl.client.HttpClients;

public class Feature_tests {

  private HttpURLConnection create_basic_browser() throws Exception {
    URL my_url = new URL("http://localhost:8080/login.jsp");
    HttpURLConnection huc = (HttpURLConnection)my_url.openConnection();
    huc.setRequestProperty("User-Agent","Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0");
    huc.setRequestProperty("Accept","text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
    huc.setRequestProperty("Accept-Language","en");
    huc.setRequestProperty("Accept-Encoding","gzip, deflate");
    huc.setRequestProperty("Referer","http://localhost:8080/");
    huc.setRequestProperty("Connection","keep-alive");
    huc.setRequestProperty("Cache-Control","max-age=0");
    return huc;
  }


  private String test_login_fields(String culture) {
    try {
      HttpURLConnection huc = create_basic_browser();
      huc.setRequestProperty("Accept-Language",culture);
      InputStream is = huc.getInputStream();
      String response = getString(is);
      return response;
    } catch (Exception ex) {
      System.out.println(ex);
      return "";
    }
  }


  private String getString(InputStream is) throws Exception {
    StringBuilder sb = new StringBuilder();
    byte[] buffer = new byte[1000];
    while ((is.read(buffer, 0, 1000)) != -1) {
      String converted = new String(buffer, StandardCharsets.UTF_8);
      sb.append(converted);
    }
    return sb.toString();
  }


  private String do_post(String culture, String body) {
    try {
      HttpURLConnection huc = create_basic_browser();
      huc.setRequestMethod("POST");
      huc.setRequestProperty("Accept-Language",culture);
      huc.setFollowRedirects(false);
      huc.connect();
      //OutputStream os = huc.getOutputStream();
      //setStringToPostContent(os, body);
      InputStream is = huc.getInputStream();
      String response = getString(is);
      return response;
    } catch (Exception ex) {
      System.out.println(ex);
      return "";
    }
  }

  @Test
  public void testee() {
    String result = do_post("en", "username=bob&password=password");
    System.out.println(result);
  }

  @Test
  public void testee_yumiee() throws Exception {
    HttpGet httpget = new HttpGet("http://localhost:8080");
    CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpGet httpGet = new HttpGet("http://localhost:8080");
    CloseableHttpResponse response1 = httpclient.execute(httpGet);
    // The underlying HTTP connection is still held by the response object
    // to allow the response content to be streamed directly from the network socket.
    // In order to ensure correct deallocation of system resources
    // the user MUST call CloseableHttpResponse#close() from a finally clause.
    // Please note that if response content is not fully consumed the underlying
    // connection cannot be safely re-used and will be shut down and discarded
    // by the connection manager. 
    try {
        System.out.println(response1.getStatusLine());
        HttpEntity entity1 = response1.getEntity();
        // do something useful with the response body
        // and ensure it is fully consumed
        EntityUtils.consume(entity1);
    } finally {
        response1.close();
    }

    HttpPost httpPost = new HttpPost("http://localhost:8080/login.jsp");
    List <NameValuePair> nvps = new ArrayList <NameValuePair>();
    nvps.add(new BasicNameValuePair("username", "bob"));
    nvps.add(new BasicNameValuePair("password", "password"));
    httpPost.setEntity(new UrlEncodedFormEntity(nvps));
    CloseableHttpResponse response2 = httpclient.execute(httpPost);

    try {
        System.out.println(response2.getStatusLine());
        HttpEntity entity2 = response2.getEntity();
        // do something useful with the response body
        // and ensure it is fully consumed
        EntityUtils.consume(entity2);
    } finally {
        response2.close();
    }
  }

  @Test
  public void test_login_page_french() {
    String login_page_text = test_login_fields("fr");
    assertTrue(login_page_text.contains("Mot de passe"));
    assertTrue(login_page_text.contains("Nom d'utilisateur"));
    assertTrue(login_page_text.contains("Page de connexion"));
    assertTrue(login_page_text.contains("S'identifier"));
  }          

  @Test
  public void test_login_page_spanish() {
    String login_page_text = test_login_fields("es");
    assertTrue(login_page_text.contains("Contraseña"));
    assertTrue(login_page_text.contains("Nombre de usuario"));
    assertTrue(login_page_text.contains("Página de registro"));
    assertTrue(login_page_text.contains("Iniciar Sesión"));
  }

  @Test
  public void test_login_page_hebrew() {
    String login_page_text = test_login_fields("he");
    assertTrue(login_page_text.contains("דף כניסה"));
    assertTrue(login_page_text.contains("שם משתמש"));
    assertTrue(login_page_text.contains("סיסמא"));
    assertTrue(login_page_text.contains("כניסה"));
  }

  @Test
  public void test_login_page_chinese() {
    String login_page_text = test_login_fields("zh");
    assertTrue(login_page_text.contains("登录页面"));
    assertTrue(login_page_text.contains("用户名"));
    assertTrue(login_page_text.contains("密码"));
    assertTrue(login_page_text.contains("登录"));
  }

  @Test
  public void test_login_page_english() {
    String login_page_text = test_login_fields("en");
    assertTrue(login_page_text.contains("Login page"));
    assertTrue(login_page_text.contains("Username"));
    assertTrue(login_page_text.contains("Password"));
    assertTrue(login_page_text.contains("Login"));
  }


  private void setStringToPostContent(
      OutputStream os, String content) throws Exception {
    final PrintStream printStream = new PrintStream(os);
    printStream.print(content);
    printStream.close();
  }


	//INTERESTING!!

	@Test
	public void trythisout() throws Exception{

		String text = 
			"GET http://localhost:8080/login.jsp HTTP/1.1\n" +
			"Host: localhost:8080\n" +
			"Connection: keep-alive\n" +
			"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n" +
			"User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36\n" +
			"Referer: http://localhost:8080/\n" +
			"Accept-Encoding: gzip, deflate, sdch\n" +
			"Accept-Language: en-US,en;q=0.8\n" +
			"\n";



		String response = talk(text);
		System.out.println(response);
	}

	private String talk(String text) throws Exception {
		// will connect to loopback on 8080
		Socket s = new Socket("localhost", 8080, null, 0);
		InputStream is = s.getInputStream();
		OutputStream os = s.getOutputStream();
		
		sendText(os, text);
		String response = getResponse(is);
		return response;
	}

  private String getResponse(InputStream is) throws Exception {
    StringBuilder sb = new StringBuilder();
    byte[] buffer = new byte[1000];
		int read = -2;
    while ((read = is.read(buffer, 0, 1000)) != -1) {
			System.out.println(read);
      String converted = new String(buffer, StandardCharsets.UTF_8);
      sb.append(converted);
    }
    return sb.toString();
  }
  
   private void sendText(
      OutputStream os, String content) throws Exception {
    final PrintStream printStream = new PrintStream(os);
    printStream.print(content);
    //printStream.close();
  }



}
