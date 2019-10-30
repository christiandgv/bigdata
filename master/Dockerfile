FROM christiandgv/hadoop-cluster-base-hdfs-spark:0.0.3

WORKDIR /root

# install Spark
# RUN wget http://apache.rediris.es/spark/spark-2.4.2/spark-2.4.2-bin-hadoop2.7.tgz && \
#    tar -xvf spark-2.4.0-bin-hadoop2.7.tgz && \
#    mv spark-2.4.0-bin-hadoop2.7 /usr/local/spark && \
#    rm spark-2.4.0-bin-hadoop2.7.tgz

COPY src/spark-2.4.4-bin-hadoop2.7.tgz /root

RUN tar -xvf spark-2.4.4-bin-hadoop2.7.tgz && \
    mv spark-2.4.4-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.4.4-bin-hadoop2.7.tgz


ENV PATH=$PATH:/usr/local/spark/bin
ENV SPARK_HOME=/usr/local/spark
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH

ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"


ADD config/spark-defaults.conf /usr/local/spark/conf
RUN chown root:root /usr/local/spark/conf/spark-defaults.conf

#ADD bin/stackanswer_2.12-0.1.jar /usr/local/spark/jars
COPY  bin/stackanswer_2.12-1.0.jar /usr/local/spark/jars

ADD config/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

VOLUME /data

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 18080 9870
