<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%
  response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  // Se a sessao ja foi autorizada, segue para a area restrita (que revalida no banco)
  String ses = (String) session.getAttribute("autorizacao");
  if (ses != null && ses.equals(session.getId())) {
    response.sendRedirect("autorizo.jsp");
    return;
  }
  String erro = request.getParameter("erro");
  String msg  = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Mini Estoque - Login</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="caixa" style="max-width:380px">
    <h1>Mini Estoque SaaS</h1>
    <% if ("sessao".equals(erro)) { %><div class="erro">Sessão inválida ou expirada. Faça login novamente.</div><% } %>
    <% if ("saiu".equals(msg)) { %><div class="ok">Você saiu do sistema.</div><% } %>
    <form action="login.jsp" method="post">
      <label>Usuário
        <input type="text" name="user" required autofocus>
      </label>
      <label>Senha
        <input type="password" name="password" required>
      </label>
      <button type="submit">Entrar</button>
    </form>
  </div>
</body>
</html>
