<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/includes/conexao.jspf" %>
<%
  String u = (String) session.getAttribute("usuario");
  String t = (String) session.getAttribute("autorizacao");
  if (u != null) {   // invalida o token no banco
    try (Connection c = abrirConexao();
         PreparedStatement p = c.prepareStatement(
           "UPDATE autenticacaoMais SET tokenVigente = 'sem-token' WHERE usuario = ? AND tokenVigente = ?")) {
      p.setString(1, u);
      p.setString(2, t == null ? "" : t);
      p.executeUpdate();
    } catch (Exception ex) { }
  }
  session.invalidate();
  response.sendRedirect("index.jsp?msg=saiu");
%>
