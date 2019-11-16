FROM java:8
COPY /target/API-javaSpringboot-0.1.0-SNAPSHOT.jar API-javaSpringboot-0.1.0-SNAPSHOT.jar
EXPOSE 8880
CMD ["sh", "-c", "java -jar API-javaSpringboot-0.1.0-SNAPSHOT.jar"]

