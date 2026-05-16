FROM tomcat:9-jdk21

COPY target/shopping-cart-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/shopping-cart.war

EXPOSE 8080

CMD ["catalina.sh", "run"]