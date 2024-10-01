FROM jupyter/pyspark-notebook:spark-3.2.1

# Copier le fichier de dépendances
COPY requirements.txt /home/jovyan/work/requirements.txt

# Télécharger le connecteur PostgreSQL
COPY postgresql-42.3.9.jar /tmp/postgresql-42.3.9.jar

# Télécharger le connecteur Kafka pour Spark (version 3.2.1)
RUN wget -P /tmp https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.2.1/spark-sql-kafka-0-10_2.12-3.2.1.jar \
    && wget -P /tmp https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.8.1/kafka-clients-2.8.1.jar

# Utiliser root pour déplacer les fichiers dans le répertoire Spark
USER root
RUN mv /tmp/spark-sql-kafka-0-10_2.12-3.2.1.jar /usr/local/spark/jars/ \
    && mv /tmp/kafka-clients-2.8.1.jar /usr/local/spark/jars/ \
    && mv /tmp/postgresql-42.3.9.jar /usr/local/spark/jars/

# Installer les dépendances Python
USER jovyan
WORKDIR /home/jovyan/work/
RUN pip install -r requirements.txt

# Configuration de Spark pour utiliser Kafka
ENV SPARK_HOME=/usr/local/spark
ENV PYSPARK_SUBMIT_ARGS="--jars ${SPARK_HOME}/jars/spark-sql-kafka-0-10_2.12-3.2.1.jar,${SPARK_HOME}/jars/kafka-clients-2.8.1.jar pyspark-shell"

# (Optionnel) Exposez le port si vous prévoyez d'utiliser un serveur web ou une interface
EXPOSE 8888
