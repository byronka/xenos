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

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Feature_tests {

    String get_cookie = 
			"POST http://localhost:8080/login.jsp HTTP/1.1\n" +
      "Host: localhost:8080\n" +
      "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0\n" +
      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\n" +
      "Accept-Language: en\n" +
      "Accept-Encoding: gzip, deflate\n" +
      "Referer: http://localhost:8080/login.jsp\n" +
      "Connection: keep-alive\n" +
      "Content-Type: application/x-www-form-urlencoded\n" +
      "Content-Length: 30\n" +
      "\n" +
      "username=bob&password=password\n" +
      "\n";


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

  @Test
  public void trylogin() throws Exception {
    String response = talk(get_cookie);
    System.out.println(response);
  }


	@Test
	public void trydashboard() throws Exception{

		String get_dashboard = 
			"GET http://localhost:8080/dashboard.jsp HTTP/1.1\n" +
			"Host: localhost:8080\n" +
			"Connection: keep-alive\n" +
			"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\n" +
			"User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36\n" +
			"Referer: http://localhost:8080/\n" +
			"Accept-Encoding: gzip, deflate, sdch\n" +
      "Cookie: %s" +
			"Accept-Language: en-US,en;q=0.8\n" +
			"\n";

		String get_cookie_response = talk(get_cookie);
    String cookie = find_cookie(get_cookie_response);
		String response = talk(String.format(get_dashboard, cookie));
		System.out.println(response);
	}





	private String talk(String text) throws Exception {
		// will connect to loopback on 8080
		Socket s = new Socket("localhost", 8080, null, 0);
		InputStream is = s.getInputStream();
		OutputStream os = s.getOutputStream();
		
		sendText(os, text);
    String content = getContent(is);
		return content;
	}


  /**
    * takes a count of the bytes from the first to the second
    * consecutive carriage return (/n/n)
    * or returns -1 if not found.
    */
  private String find_cookie(String headers) {
    String cookie_search = "Set-Cookie: ([a-zA-Z_0-9]+?)";
    Pattern p = Pattern.compile(cookie_search); 
    Matcher m = p.matcher(headers);
    if (m.find()) {
      String cookie = m.group(1);
      return cookie;
    }
    return "";
  }

  /**
    * takes a count of the bytes from the first to the second
    * consecutive carriage return (/n/n)
    * or returns -1 if not found.
    */
  private int find_header_length(String headers) {
    String end_of_headers = "\r\n\r\n|\n\n"; 
    Pattern p = Pattern.compile(end_of_headers, Pattern.MULTILINE);
    Matcher m = p.matcher(headers);
    if (m.find()) {
      Integer length_of_headers_region = m.end();
      return length_of_headers_region;
    }
    return -1;
  }

  /**
    * looks for "content-length: 123" in the string given
    * if it find anything, returns that value, otherwise, -1
    */
  private int find_content_length(String headers) {
    String content_length = "Content-Length: ([0-9]+)"; 
    Pattern p = Pattern.compile(content_length);
    Matcher m = p.matcher(headers);
    if (m.find()) {
      Integer size = Integer.parseInt(m.group(1));
      return size;
    }
    return -1;
  }


  private String 
    getContent(InputStream is) throws Exception {
    StringBuilder sb = new StringBuilder();
    byte[] buffer = new byte[1000];
    int read = 0;
    int total_read = 0;
    int content_length = -1;
    int header_length = -1;
    int count = 0;
    while (true) {
      if ((read = is.read(buffer, 0, 1000)) < 1) {
        System.out.println("breaking because we read " + read + " bytes");
        break;
      }

      total_read += read;
      count++;
      String read_string = new String(buffer, StandardCharsets.UTF_8);
      sb.append(read_string);
      if (content_length == -1) {  //First, did we get content-length? 
        content_length = find_content_length(read_string);
      }
      if (header_length == -1) {  //Then, do we know the length of the headers section?
        header_length = find_header_length(read_string);
      }
      if (content_length > -1 && //if we have everything, and have exceeded the length, break.
          header_length > -1 && 
          total_read <= (content_length + header_length)) {
        System.out.println("response fully read. total_length: " + total_read);
        break;
      }
      if (count > 5) {   // safety - we don't want to get in an infinite loop
        System.out.println("*** breaking after count of 5 ***");
        break;
      }
    }
    return sb.toString();
  }

  
   private void sendText(
      OutputStream os, String content) throws Exception {
    final PrintStream printStream = new PrintStream(os);
    printStream.print(content); //send our request to server
  }



}
