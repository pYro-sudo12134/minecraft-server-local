FROM eclipse-temurin:21-jdk

WORKDIR /minecraft

RUN apt-get update && apt-get install -y wget && \
    wget -O forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-installer.jar && \
    java -jar forge-installer.jar --installServer && \
    rm forge-installer.jar && \
    apt-get clean

RUN echo "-XX:+UseZGC" >> user_jvm_args.txt && \
    echo "-Xmx8G" >> user_jvm_args.txt && \
    echo "-Xms4G" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote.port=9010" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote.rmi.port=9010" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote.authenticate=false" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote.ssl=false" >> user_jvm_args.txt && \
    echo "-Dcom.sun.management.jmxremote.local.only=false" >> user_jvm_args.txt && \
    echo "-Djava.rmi.server.hostname=minecraft" >> user_jvm_args.txt

RUN echo "eula=true" > eula.txt

CMD ["./run.sh"]