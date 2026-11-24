#!/bin/bash
# Implanta a aplicacao no Tomcat da VM.
# Uso (dentro da pasta do projeto clonado):  sudo ./scripts/deploy.sh
set -e
TOMCAT=/opt/tomcat10
APP=estoque
JAR_URL="https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar"

echo "[1/4] Criando/atualizando banco de dados..."
mysql -u root < conf/script.sql

echo "[2/4] Baixando driver JDBC (se necessario)..."
if ! ls webapp/WEB-INF/lib/mysql-connector-j-*.jar >/dev/null 2>&1; then
  wget -q -P webapp/WEB-INF/lib "$JAR_URL"
fi

echo "[3/4] Copiando aplicacao para o Tomcat..."
rm -rf $TOMCAT/webapps/$APP
cp -r webapp $TOMCAT/webapps/$APP

echo "[4/4] Reiniciando o Tomcat..."
$TOMCAT/bin/shutdown.sh >/dev/null 2>&1 || true
sleep 3
$TOMCAT/bin/startup.sh

echo "Pronto! Acesse: http://$(hostname -I | awk '{print $1}'):8080/$APP/"
