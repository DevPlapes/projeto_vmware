<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/includes/conexao.jspf" %>
<%@ include file="/WEB-INF/includes/valida.jspf" %>
<%
  // ---------- AUTORIZACAO: apenas perfil "admin" pode cadastrar ----------
  String aviso = null;
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    if (!"admin".equals(perfilSessao)) {
      response.setStatus(403);
      aviso = "Acesso negado: apenas administradores podem cadastrar produtos.";
    } else {
      try (Connection c = abrirConexao();
           PreparedStatement ins = c.prepareStatement(
             "INSERT INTO produto (nome, categoria, quantidade, preco) VALUES (?, ?, ?, ?)")) {
        ins.setString(1, request.getParameter("nome"));
        ins.setString(2, request.getParameter("categoria"));
        ins.setInt(3, Integer.parseInt(request.getParameter("quantidade")));
        ins.setBigDecimal(4, new java.math.BigDecimal(request.getParameter("preco")));
        ins.executeUpdate();
        response.sendRedirect("produtos.jsp?ok=1");
        return;
      } catch (Exception ex) {
        aviso = "Não foi possível cadastrar. Confira os dados informados.";
      }
    }
  }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>Mini Estoque - Produtos</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="caixa">
    <h1>Estoque de produtos</h1>
    <p><small>Logado como <b><%= esc(usuarioSessao) %></b> (<%= esc(perfilSessao) %>)</small></p>
    <% if (aviso != null) { %><div class="erro"><%= esc(aviso) %></div><% } %>
    <% if ("1".equals(request.getParameter("ok"))) { %><div class="ok">Produto cadastrado com sucesso.</div><% } %>

    <table>
      <tr><th>#</th><th>Produto</th><th>Categoria</th><th>Qtd</th><th>Preço (R$)</th></tr>
      <%
        try (Connection c2 = abrirConexao();
             Statement st = c2.createStatement();
             ResultSet rs = st.executeQuery(
               "SELECT idProduto, nome, categoria, quantidade, preco FROM produto ORDER BY idProduto")) {
          while (rs.next()) {
            out.println("<tr><td>" + rs.getInt(1) + "</td><td>" + esc(rs.getString(2)) + "</td><td>"
              + esc(rs.getString(3)) + "</td><td>" + rs.getInt(4) + "</td><td>"
              + String.format("%.2f", rs.getBigDecimal(5)) + "</td></tr>");
          }
        } catch (Exception ex) {
          out.println("<tr><td colspan='5'>Erro ao consultar o banco de dados.</td></tr>");
        }
      %>
    </table>

    <% if ("admin".equals(perfilSessao)) { %>
      <h2 style="font-size:17px;margin-top:26px">Cadastrar produto (somente admin)</h2>
      <form action="produtos.jsp" method="post">
        <label>Nome <input type="text" name="nome" required></label>
        <label>Categoria <input type="text" name="categoria" required></label>
        <label>Quantidade <input type="number" name="quantidade" min="0" required></label>
        <label>Preço <input type="number" name="preco" step="0.01" min="0" required></label>
        <button type="submit">Cadastrar</button>
      </form>
    <% } else { %>
      <p><small>Seu perfil permite apenas consulta.</small></p>
    <% } %>

    <p><a class="btn" href="autorizo.jsp">Voltar</a>
       <a class="btn" href="logout.jsp" style="background:#8a2c2c">Sair</a></p>
  </div>
</body>
</html>
