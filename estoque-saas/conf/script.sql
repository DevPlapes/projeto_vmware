-- =====================================================================
-- Projeto: Mini Estoque SaaS  |  Innovation Lab - SaaS Infrastructure
-- Execucao na VM:  sudo mysql -u root < conf/script.sql
-- (pode ser executado varias vezes: usa "if not exists")
-- =====================================================================
create user if not exists 'saas'@'localhost' identified by 'saas';
create database if not exists enterprise character set utf8mb4;
grant all privileges on enterprise.* to 'saas'@'localhost';
flush privileges;
use enterprise;

-- TABELA 1: autenticacao e controle de sessao (token vigente)
create table if not exists autenticacaoMais (
  tokenVigente varchar(100) not null default 'sem-token',
  usuario varchar(50) not null,
  senha varchar(100) not null,
  perfil varchar(20) not null default 'usuario',   -- 'admin' ou 'usuario'
  sessaoUltima varchar(100),
  dataHoraUltimaAutorizacao datetime,
  primary key (tokenVigente, usuario),
  unique key uk_usuario (usuario)
);

-- TABELA 2: dados do negocio (produtos do estoque)
create table if not exists produto (
  idProduto int auto_increment primary key,
  nome varchar(100) not null,
  categoria varchar(50) not null,
  quantidade int not null default 0,
  preco decimal(10,2) not null default 0,
  dataCadastro datetime not null default current_timestamp
);

-- Usuarios de teste (senha guardada como hash SHA-256)
-- administrador / admin123   (perfil admin: pode cadastrar produtos)
-- maria         / user123    (perfil usuario: somente consulta)
insert ignore into autenticacaoMais (tokenVigente, usuario, senha, perfil)
values ('sem-token', 'administrador', sha2('admin123', 256), 'admin'),
       ('sem-token', 'maria',         sha2('user123', 256),  'usuario');

-- Produtos de exemplo (so insere se ainda nao existirem)
insert into produto (nome, categoria, quantidade, preco)
select 'Teclado USB', 'Perifericos', 25, 59.90 from dual
where not exists (select 1 from produto where nome = 'Teclado USB');
insert into produto (nome, categoria, quantidade, preco)
select 'Mouse sem fio', 'Perifericos', 40, 39.90 from dual
where not exists (select 1 from produto where nome = 'Mouse sem fio');
insert into produto (nome, categoria, quantidade, preco)
select 'Monitor 24 pol', 'Monitores', 10, 799.00 from dual
where not exists (select 1 from produto where nome = 'Monitor 24 pol');
