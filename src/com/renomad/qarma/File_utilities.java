package com.renomad.qarma;

import java.io.IOException;
import java.io.File;
import java.io.FileReader;
import java.io.FileNotFoundException;

public class File_utilities {

  /**
    *Given a path to a file, get all the text from it as a string.
    *
    * @param filepath the path to the file in question.
    * @return A string containing all the text from the file.
    */
  public static String get_text_from_file(String filepath) {
    FileReader fr = null;
    File file = new File(filepath);
    long length_of_array = file.length();
    char[] buffer = new char[(int)length_of_array+1];
    try {
      fr = new FileReader(filepath);
      fr.read(buffer);
      fr.close();
    } catch (FileNotFoundException e) {
      //handle the error
    } catch (IOException e) {
      //handle
    } catch (Exception e) {
      //handle
    }
     return new String(buffer);
  }

}
