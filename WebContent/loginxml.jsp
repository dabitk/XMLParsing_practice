<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml; charset=utf-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*" %>
<% //로그인 체크
	String thispage="loginxml.jsp"; //현재 페이지를 가리키는 URL
	String login_url="login.jsp?rtn_url="+thispage; //로그인되어 있지 않으면 login_url에 있는 주소로 리다이렉트 시키는 용도.
	
	String loginVal=(String) session.getAttribute("loginOK");
	if(loginVal == null || !loginVal.equals("YES")) //loginOK속성 값이 "null" 또는 "YES가 아닌 경우" 로그인 페이지로 날린다.
		response.sendRedirect(login_url); //로그인 필요
%>
<%
	//DB 커넥션을 맺는 부분.
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.14:3306/jsptest","root","1234");
	Statement stmt = conn.createStatement();
	
	//DB에 SELECT 쿼리를 날리고 resultset에 담아서 받은 결과를 xml형태로 출력하는 부분.
	ResultSet rset = stmt.executeQuery("select * from examtable");
	out.println("<datas>");
	while(rset.next()){
		out.println("<data>");
		
		out.println("<name>"+rset.getString(1)+"</name>");
		out.println("<studentid>"+Integer.toString(rset.getInt(2))+"</studentid>");
		out.println("<kor>"+rset.getString(3)+"</kor>");
		out.println("<eng>"+rset.getString(4)+"</eng>");
		out.println("<mat>"+rset.getString(5)+"</mat>");
		
		out.println("</data>");
	}
	out.println("</datas>");
	//커넥션을 포함한 모든 리소스를 닫는 부분.
	stmt.close();
	conn.close();
%>
