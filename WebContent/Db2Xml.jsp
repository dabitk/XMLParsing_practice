<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*" %>
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.23.14:3306/jsptest","root","1234");
	PreparedStatement pstmt = conn.prepareStatement("SELECT * from examtable;");
	
	ResultSet rset = pstmt.executeQuery();
	out.println("<datas>");
	while (rset.next()){
		out.println("<data>");
		out.println("<name>"+rset.getString(1)+"</name>");
		out.println("<studentid>"+Integer.toString(rset.getInt(2))+"</studentid>");
		out.println("<kor>"+rset.getString(3)+"</kor>");
		out.println("<eng>"+rset.getString(4)+"</eng>");
		out.println("<mat>"+rset.getString(5)+"</mat>");
		
		out.println("</data>");
	}
	out.println("</datas>");
	pstmt.close();
	conn.close();
	//kopo02 DB레코드를 XML형태로 포맷하기 - 20.02.04 실습완료.
%>

