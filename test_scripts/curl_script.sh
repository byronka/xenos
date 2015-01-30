#!/bin/sh

 curl -s http://localhost:8080/xenos/dashboard.jsp --cookie xenos_cookie=4 >> /dev/null
 curl -s http://localhost:8080/xenos/login.jsp --cookie xenos_cookie=4 >> /dev/null
 curl -s http://localhost:8080/xenos/index.jsp --cookie xenos_cookie=4 >> /dev/null
 curl -s http://localhost:8080/xenos/request.jsp --cookie xenos_cookie=4 >> /dev/null
 curl -s http://localhost:8080/xenos/create_request.jsp --cookie xenos_cookie=4 >> /dev/null
 curl -s http://localhost:8080/xenos/logout.jsp --cookie xenos_cookie=4 >> /dev/null
