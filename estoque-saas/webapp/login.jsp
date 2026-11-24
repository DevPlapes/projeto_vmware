<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/includes/conexao.jspf" %>
<%
  response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  // Etapa 1: todo acesso a esta pagina comeca SEM autorizacao
  session.setAttribute("autorizacao", "descabida");

  String user = request.getParameter("user");
  String pass = request.getParameter("password");
  boolean autorizado = false;
  boolean erroInterno = false;

  // Etapa 2: AVERIGUACAO (so aceita POST com usuario e senha)
  if ("POST".equalsIgnoreCase(request.getMethod()) && user != null && pass != null && !user.isEmpty()) {
    try (Connection c = abrirConexao();
         PreparedStatement q = c.prepareStatement(
           "SELECT perfil FROM autenticacaoMais WHERE usuario = ? AND senha = SHA2(?, 256)")) {
      q.setString(1, user);
      q.setString(2, pass);
      try (ResultSet rs = q.executeQuery()) {
        if (rs.next()) {
          // Etapa 3: ATUALIZACAO DO BD COM O TOKEN DA SESSAO
          request.changeSessionId();            // novo Id apos login (evita session fixation)
          String token = session.getId();
          try (PreparedStatement u = c.prepareStatement(
                 "UPDATE autenticacaoMais SET tokenVigente = ?, sessaoUltima = ?, " +
                 "dataHoraUltimaAutorizacao = NOW() WHERE usuario = ?")) {
            u.setString(1, token);
            u.setString(2, token);
            u.setString(3, user);
            u.executeUpdate();
          }
          session.setAttribute("autorizacao", token);
          session.setAttribute("usuario", user);
          autorizado = true;
        }
      }
    } catch (Exception ex) {
      erroInterno = true;
    }
  }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Mini Estoque - Autenticação</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="caixa centro" style="max-width:420px">
    <% if (autorizado) { %>
      <div class="ok">AUTORIZADO</div>
      <p>Bem-vindo(a), <b><%= esc(user) %></b>.</p>
      <a class="btn" href="autorizo.jsp">ACESSE MAIS</a>
    <% } else if (erroInterno) { %>
      <div class="erro">Erro ao acessar o banco de dados. Verifique se o MySQL está ativo.</div>
      <a class="btn" href="index.jsp">Voltar</a>
    <% } else { %>
      <div class="erro">TOKEN NÃO AUTORIZADO. Usuário ou senha incorretos.</div>
      <a class="btn" href="index.jsp">Tentar novamente</a>
    <% } %>
  </div>
</body>
</html>
