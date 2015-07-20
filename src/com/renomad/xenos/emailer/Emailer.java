package com.renomad.xenos.emailer;

import com.renomad.xenos.Requestoffer_utils;
import java.io.OutputStream;
import java.io.PrintStream;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.text.SimpleDateFormat;

@WebListener
public class Emailer implements ServletContextListener, Runnable {

  private volatile boolean keepRunning; // toggle the thread on / off

  public void contextInitialized(ServletContextEvent context) {
    System.out.println("starting emailer");
    Thread emailerThread = new Thread(this);
    emailerThread.setDaemon(true);
    keepRunning = true;
    emailerThread.start();
  }

  public void contextDestroyed(ServletContextEvent event) {
    System.out.println("stopping emailer");
    keepRunning = false;
  }

  private static String getTimestamp() {
    Date myDate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    return sdf.format(myDate);
  }

  public void run() {
    while(true) {
      System.out.println(getTimestamp() + " Checking for messages to email...");
      sendEmail();
      try{
        //wake up every second to see if we keep running
        for (int i = 0; i < (60 * 5); i++) { // 5 minutes total
          if (!keepRunning) {break;}
          Thread.sleep(1000);
        }
      } catch(Exception e) {
        System.out.println(e);
      }
    }
  } 

  public void sendEmail() {
    Requestoffer_utils.EmailInformation[] messagesPerUser = 
      Requestoffer_utils.get_messages_for_user_email();

    if (messagesPerUser.length == 0) {
      System.out.println("Nothing to send");
      return;
    }

    Map<String, List<Requestoffer_utils.EmailInformation>> map 
      = new HashMap<String, List<Requestoffer_utils.EmailInformation>>();

    // group messages by email
    for (Requestoffer_utils.EmailInformation ei : messagesPerUser) {
       String key = ei.email;
       if (map.get(key) == null) {
          map.put(key, new ArrayList<Requestoffer_utils.EmailInformation>());
       }
       map.get(key).add(ei);
    }


    // create aggregate message per email and send.
    for (Map.Entry<String, List<Requestoffer_utils.EmailInformation>> entry : map.entrySet()) {
      List<Requestoffer_utils.EmailInformation> values = entry.getValue();

      StringBuilder emailBody = new StringBuilder("Hi, you have received new messages on Favrcafe.  Here they are:\n");
      for (Requestoffer_utils.EmailInformation info : values) {
        emailBody.append(info.message + "\n\n");
      }
      emailBody.append("\n\nhttps://favrcafe.com");

      String emailAddress = entry.getKey();

      StringBuilder emailMessage = new StringBuilder();
      emailMessage.append(              "From: favrcafe@favrcafe.com\n");
      emailMessage.append(String.format("To: %s\n",emailAddress));
      emailMessage.append(              "Subject: [Favrcafe new messages]\n\n");
      emailMessage.append(emailBody.toString());

      //set up a stream to send the email message to
      ProcessBuilder pb = new ProcessBuilder("ssmtp",emailAddress,"-C/home/byron/dev/xenos/utils/ssmtp.conf","&");

      //send the email
      try {
        Process process = pb.start();
        OutputStream os = process.getOutputStream();
        final PrintStream printStream = new PrintStream(os);
        printStream.print(emailMessage.toString());
        printStream.close();
      } catch(Exception e) {
        System.out.println(e);
      }
    }

    }

  }
