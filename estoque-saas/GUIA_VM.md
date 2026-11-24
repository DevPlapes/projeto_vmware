# Guia de implantação na VM (Ubuntu + VMware)

> Se o professor já entregou uma VM com MySQL e Tomcat em `/opt/tomcat10`, pule para o passo 4.

## 1. Rede da VM
No VMware, deixe o adaptador de rede em **Bridged** (ou NAT) e descubra o IP: `ip a` (interface `ens33`).
Se perder a rede: `sudo ip link set ens33 down && sudo ip link set ens33 up`.

## 2. Pacotes
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk mysql-server git wget
sudo systemctl status mysql      # deve estar "active (running)"
```

## 3. Tomcat 10 (se ainda não existir)
Pegue o link da versão atual em https://tomcat.apache.org/download-10.cgi (arquivo `tar.gz` em *Core*):
```bash
cd /tmp
wget <LINK-DO-apache-tomcat-10.x.x.tar.gz>
sudo mkdir -p /opt/tomcat10
sudo tar xzf apache-tomcat-10.*.tar.gz -C /opt/tomcat10 --strip-components=1
sudo chmod +x /opt/tomcat10/bin/*.sh
```

## 4. Variáveis do serviço
```bash
sudo cp conf/setenv.sh /opt/tomcat10/bin/setenv.sh
sudo chmod +x /opt/tomcat10/bin/setenv.sh
```

## 5. Implantar
```bash
sudo ./scripts/deploy.sh
```
O script cria o banco, baixa o driver JDBC, copia o app para `/opt/tomcat10/webapps/estoque` e reinicia o Tomcat.

## 6. Acessar
No navegador: `http://IP_DA_VM:8080/estoque/`
Se não abrir: `sudo ufw allow 8080/tcp` e confira `sudo ss -tlnp | grep 8080`.

## 7. Roteiro de demonstração (vídeo)
1. Abrir `index.jsp`, tentar login com senha errada → *TOKEN NÃO AUTORIZADO*.
2. Entrar como `maria / user123` → ver estoque (sem formulário de cadastro).
3. No MySQL: `select tokenVigente, usuario from enterprise.autenticacaoMais;` → token gravado.
4. Entrar como `administrador / admin123` → cadastrar um produto.
5. No MySQL, zerar o token (`update autenticacaoMais set tokenVigente='sem-token' where usuario='administrador';`) e atualizar a página → volta ao login (validação no banco).
6. Clicar em Sair → token revogado.

## 8. GitHub
```bash
git init
git add .
git commit -m "Projeto Mini Estoque SaaS"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
git push -u origin main
```
Depois de cada alteração: `git add .` → `git commit -m "o que mudou"` → `git push origin main`.
