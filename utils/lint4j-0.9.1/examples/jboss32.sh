#!/bin/sh 

if [ $# -lt 1 ] ; then
    echo "$0: Usage: <path to your jboss 3.2 source distribution> [options]"
    exit 1
fi

prg=$0
dirname=`dirname $prg`
path=$1
options=$2

$dirname/../bin/lint4j -J "-Xms100M -Xmx400M" $options -sourcepath $path/tools/lib/ant.jar:$path/cluster/output/gen-src:$path/common/output/gen-src:$path/console/output/gen-src:$path/jmx/output/gen-src:$path/management/output/gen-src:$path/messaging/output/gen-src:$path/server/output/gen-src:$path/system/output/gen-src:$path/transaction/output/gen-src:$path/varia/output/gen-src:$path/catalina/src/main:$path/cluster/src/main:$path/common/src/main:$path/iiop/src/main:$path/j2ee/src/main:$path/jboss.net/src/main:$path/jmx/src/main:$path/management/src/main:$path/messaging/src/main:$path/naming/src/main:$path/pool/src/main:$path/security/src/main:$path/server/src/main:$path/system/src/main:$path/tomcat41/src/main:$path/varia/src/main  -classpath $path/thirdparty/antlr/lib/antlr-2.7.4.jar:$path/thirdparty/apache/addressing/lib/addressing-1.0.jar:$path/thirdparty/apache/avalon/lib/avalon-framework.jar:$path/thirdparty/apache/bcel/lib/bcel.jar:$path/thirdparty/apache/commons/lib/commons-collections.jar:$path/thirdparty/apache/commons/lib/commons-discovery.jar:$path/thirdparty/apache/commons/lib/commons-httpclient.jar:$path/thirdparty/apache/commons/lib/commons-logging.jar:$path/thirdparty/apache/jaxme/lib/jaxmexs.jar:$path/thirdparty/apache/log4j/lib/log4j.jar:$path/thirdparty/apache/log4j/lib/snmpTrapAppender.jar:$path/thirdparty/apache/slide/client/lib/webdavlib.jar:$path/thirdparty/apache/tomcat41/bootstrap.jar:$path/thirdparty/apache/tomcat41/catalina.jar:$path/thirdparty/apache/tomcat41/commons-beanutils.jar:$path/thirdparty/apache/tomcat41/commons-collections.jar:$path/thirdparty/apache/tomcat41/commons-digester.jar:$path/thirdparty/apache/tomcat41/commons-logging.jar:$path/thirdparty/apache/tomcat41/jakarta-regexp-1.3.jar:$path/thirdparty/apache/tomcat41/jasper-compiler.jar:$path/thirdparty/apache/tomcat41/jasper-runtime.jar:$path/thirdparty/apache/tomcat41/naming-common.jar:$path/thirdparty/apache/tomcat41/naming-resources.jar:$path/thirdparty/apache/tomcat41/servlets-common.jar:$path/thirdparty/apache/tomcat41/servlets-default.jar:$path/thirdparty/apache/tomcat41/servlets-invoker.jar:$path/thirdparty/apache/tomcat41/servlets-webdav.jar:$path/thirdparty/apache/tomcat41/tomcat-coyote.jar:$path/thirdparty/apache/tomcat41/tomcat-http11.jar:$path/thirdparty/apache/tomcat41/tomcat-jk2.jar:$path/thirdparty/apache/tomcat41/tomcat-util.jar:$path/thirdparty/apache/tomcat50/catalina-manager.jar:$path/thirdparty/apache/tomcat50/catalina-optional.jar:$path/thirdparty/apache/tomcat50/catalina.jar:$path/thirdparty/apache/tomcat50/commons-beanutils.jar:$path/thirdparty/apache/tomcat50/commons-collections.jar:$path/thirdparty/apache/tomcat50/commons-digester.jar:$path/thirdparty/apache/tomcat50/commons-el.jar:$path/thirdparty/apache/tomcat50/commons-logging.jar:$path/thirdparty/apache/tomcat50/commons-modeler.jar:$path/thirdparty/apache/tomcat50/jakarta-regexp-1.3.jar:$path/thirdparty/apache/tomcat50/jasper-compiler.jar:$path/thirdparty/apache/tomcat50/jasper-runtime.jar:$path/thirdparty/apache/tomcat50/jsp-api.jar:$path/thirdparty/apache/tomcat50/naming-common.jar:$path/thirdparty/apache/tomcat50/naming-resources.jar:$path/thirdparty/apache/tomcat50/servlet-api.jar:$path/thirdparty/apache/tomcat50/servlets-common.jar:$path/thirdparty/apache/tomcat50/servlets-default.jar:$path/thirdparty/apache/tomcat50/servlets-invoker.jar:$path/thirdparty/apache/tomcat50/servlets-webdav.jar:$path/thirdparty/apache/tomcat50/tomcat-coyote.jar:$path/thirdparty/apache/tomcat50/tomcat-http11.jar:$path/thirdparty/apache/tomcat50/tomcat-jk2.jar:$path/thirdparty/apache/tomcat50/tomcat-util.jar:$path/thirdparty/apache/velocity/lib/velocity.jar:$path/thirdparty/apache/wss4j/lib/wss4j.jar:$path/thirdparty/apache/xalan/lib/xalan.jar:$path/thirdparty/apache/xerces/lib/resolver.jar:$path/thirdparty/apache/xerces/lib/xercesImpl.jar:$path/thirdparty/apache/xerces/lib/xml-apis.jar:$path/thirdparty/beanshell/beanshell/lib/bsh-1.3.0.jar:$path/thirdparty/bouncycastle/bouncycastle/lib/bcprov-jdk14-124.jar:$path/thirdparty/cglib/lib/cglib-full-2.0.1.jar:$path/thirdparty/dom4j/dom4j/lib/dom4j.jar:$path/thirdparty/dom4j/dom4j/lib/jaxen-1.1-beta-4.jar:$path/thirdparty/eclipse/jdt/lib/jdtcore.jar:$path/thirdparty/exolab/castor/lib/castor.jar:$path/thirdparty/exolab/tyrex/lib/tyrex.jar:$path/thirdparty/gjt/jpl-util/lib/jpl-pattern.jar:$path/thirdparty/gjt/jpl-util/lib/jpl-util.jar:$path/thirdparty/gnu/getopt/lib/getopt.jar:$path/thirdparty/gnu/regexp/lib/gnu-regexp.jar:$path/thirdparty/hibernate/lib/antlr-2.7.4.jar:$path/thirdparty/hibernate/lib/hibernate-metadata.jar:$path/thirdparty/hibernate/lib/hibernate2.jar:$path/thirdparty/hibernate/lib/hibernate3.jar:$path/thirdparty/hsql/hsql/lib/hsql.jar:$path/thirdparty/hsqldb/hsqldb/lib/hsqldb.jar:$path/thirdparty/ibm/bsf/lib/bsf.jar:$path/thirdparty/ibm/wsdl4j/lib/wsdl4j.jar:$path/thirdparty/informa/rss/lib/informa.jar:$path/thirdparty/informix/informix/lib/ifxjdbc.jar:$path/thirdparty/jacorb/jacorb/lib/idl.jar:$path/thirdparty/jacorb/jacorb/lib/idl_g.jar:$path/thirdparty/jacorb/jacorb/lib/jacorb.jar:$path/thirdparty/jacorb/jacorb/lib/jacorb_g.jar:$path/thirdparty/javagroups/javagroups/lib/jgroups.jar:$path/thirdparty/javassist/javassist/lib/javassist.jar:$path/thirdparty/jdom/beta-7/lib/jdom.jar:$path/thirdparty/jflex/jflex/lib/jflex.jar:$path/thirdparty/jfreechart/jfreechart/lib/jcommon.jar:$path/thirdparty/jfreechart/jfreechart/lib/jfreechart.jar:$path/thirdparty/jregex/jregex/lib/jregex.jar:$path/thirdparty/juddi/juddi/lib/juddi.jar:$path/thirdparty/junit/junit/lib/junit.jar:$path/thirdparty/junitejb/junitejb/lib/junitejb.jar:$path/thirdparty/jython/jython/jython.jar:$path/thirdparty/mortbay/jetty/lib/javax.servlet.jar:$path/thirdparty/mortbay/jetty/lib/org.apache.jasper.jar:$path/thirdparty/mysql/mysql/lib/mysql-connector-java-3.0.0-beta-bin.jar:$path/thirdparty/mysql/mysql/lib/mysql-connector-java-3.0.9-stable-bin.jar:$path/thirdparty/odmg/lib/odmg-3.0.jar:$path/thirdparty/opennms/joesnmp/lib/joesnmp.jar:$path/thirdparty/opensaml/lib/opensaml.jar:$path/thirdparty/oswego/concurrent/lib/concurrent.jar:$path/thirdparty/qdox/qdox/lib/qdox.jar:$path/thirdparty/sleepycat/lib/je.jar:$path/thirdparty/sourceforge/dnsjava/lib/dnsjava-1.4.3.jar:$path/thirdparty/sourceforge/tapestry/lib/ext/jakarta-oro-2.0.6.jar:$path/thirdparty/sourceforge/tapestry/lib/ext/ognl-2.1.4-opt.jar:$path/thirdparty/sourceforge/tapestry/lib/net.sf.tapestry-2.2.jar:$path/thirdparty/sourceforge/tapestry/lib/net.sf.tapestry.contrib-2.2.jar:$path/thirdparty/sun/jaas/lib/jaas.jar:$path/thirdparty/sun/jaf/lib/activation.jar:$path/thirdparty/sun/javamail/lib/imap.jar:$path/thirdparty/sun/javamail/lib/mail.jar:$path/thirdparty/sun/javamail/lib/mailapi.jar:$path/thirdparty/sun/javamail/lib/pop3.jar:$path/thirdparty/sun/javamail/lib/smtp.jar:$path/thirdparty/sun/jce/lib/jce1_2_1.jar:$path/thirdparty/sun/jce/lib/local_policy.jar:$path/thirdparty/sun/jce/lib/sunjce_provider.jar:$path/thirdparty/sun/jce/lib/US_export_policy.jar:$path/thirdparty/sun/jmx/lib/jmxgrinder.jar:$path/thirdparty/sun/jmx/lib/jmxri.jar:$path/thirdparty/sun/jmx/lib/jmxtools.jar:$path/thirdparty/sun/jsse/lib/jcert.jar:$path/thirdparty/sun/jsse/lib/jnet.jar:$path/thirdparty/sun/jsse/lib/jsse.jar:$path/thirdparty/sun/jts/lib/jts.jar:$path/thirdparty/sun/servlet/lib/servlet.jar:$path/thirdparty/trove/trove/lib/trove.jar:$path/thirdparty/website/jspwiki/lib/ant.jar:$path/thirdparty/website/jspwiki/lib/jasper-compiler.jar:$path/thirdparty/website/jspwiki/lib/jasper-runtime.jar:$path/thirdparty/website/jspwiki/lib/JSPWiki.jar:$path/thirdparty/website/jspwiki/lib/multipartrequest.jar:$path/thirdparty/website/jspwiki/lib/oro.jar:$path/thirdparty/website/jspwiki/lib/oscache.jar:$path/thirdparty/website/jspwiki/lib/xmlrpc.jar:$path/thirdparty/wutka/dtdparser/lib/dtdparser121.jar:$path/thirdparty/xdoclet/xdoclet/lib/commons-logging.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-bea-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-ejb-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-java-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-jboss-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-jdo-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-jmx-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-web-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-xdoclet-module-jb4.jar:$path/thirdparty/xdoclet/xdoclet/lib/xdoclet-xjavadoc-jb4.jar:$path/thirdparty/xml/sax/lib/sax2-ext.jar:$path/thirdparty/xml/sax/lib/sax2.jar -exclude org.jboss.test.\* org.jboss.\*