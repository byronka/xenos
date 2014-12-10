#!/bin/bash
set -o verbose
set -x
javadoc -sourcepath $QARMA_HOME/src \
           -d $QARMA_HOME/docs/javadocs \
           -use \
           -splitIndex \
           -windowtitle 'Qarma api' \
           -doctitle 'Qarma api' \
           -header '<b>Qarma API</b>' \
           com.renomad.qarma
#javadoc -d $QARMA_HOME/docs/javadocs -sourcepath /home/src java.awt /home/src/java/applet/Applet.java
