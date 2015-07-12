package com.renomad.xenos.emailer;

import com.renomad.xenos.Requestoffer_utils;
import java.util.Map;
import java.util.Map.Entry;
import java.util.List;
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
      testEmail();
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

  public void testEmail() {
    Requestoffer_utils.EmailInformation[] messagesPerUser = 
      Requestoffer_utils.get_messages_for_user_email();
    if (messagesPerUser.length == 0) {
      System.out.println("Nothing to send");
      return;
    }
    for(Requestoffer_utils.EmailInformation ei : messagesPerUser) {
      System.out.println("user id is " + ei.user_id);
      System.out.println("values are " + ei.message);
    }
  }


}
