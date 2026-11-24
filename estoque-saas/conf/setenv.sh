#!/bin/sh
# Variaveis de ambiente lidas pelo Tomcat na inicializacao.
# Copiar para /opt/tomcat10/bin/setenv.sh  (chmod +x) e reiniciar o Tomcat.
export DB_URL="jdbc:mysql://localhost:3306/enterprise?useSSL=false&allowPublicKeyRetrieval=true"
export DB_USER="saas"
export DB_PASS="saas"
