<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/includes/conexao.jspf" %>
<%@ include file="/WEB-INF/includes/valida.jspf" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Mini Estoque - Área restrita</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="caixa">
    <h1>Área restrita</h1>
    <p>Usuário: <b><%= esc(usuarioSessao) %></b> &nbsp;|&nbsp; Perfil: <b><%= esc(perfilSessao) %></b></p>
    <p><small>Token da sessão (validado no banco de dados): <%= esc(session.getId()) %></small></p>
    <a class="btn" href="produtos.jsp">Ver estoque de produtos</a>
    <a class="btn" href="logout.jsp" style="background:#8a2c2c">Sair</a>
  </div>
</body>
</html>
