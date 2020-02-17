<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*,java.io.*,java.util.*,java.text.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%
	String username = request.getParameter("username"); //아이디
	String userpasswd = request.getParameter("userpasswd"); //비밀번호
	String rtn_url = request.getParameter("rtn_url"); //보통 loginxml.jsp를 담고있음.
	String logincnt = request.getParameter("logincnt"); //로그인 시도 횟수를 기록함.
	if(logincnt == null) logincnt="0"; //logincnt 패러미터가 없는 경우 0으로 초기화
	if(username == null) username="";  //username 패러미터가 없는 경우 ""로 초기화
	if(userpasswd == null) userpasswd=""; //userpasswd 패러미터가 없는 경우 ""로 초기화
	if(rtn_url == null) rtn_url=""; //rtn_url 패러미터가 없는 경우 ""로 초기화
	
	if(username.equals("kopoctc") && userpasswd.equals("kopoctc")){ //login OK
		//로그인 성공한 경우
		session.setAttribute("loginOK","YES"); //세션에 상태값을 저장한 뒤 xml 조회 페이지로 넘어간다.
		response.sendRedirect(rtn_url); //다시 돌아감
	}else{//login Err
		//이 경우는 로그인이 실패한 경우로 logincnt를 +1 한다.
		logincnt=Integer.toString(Integer.parseInt(logincnt)+1); 
	}
%>
</head>
<body>
<form method="post" action="login.jsp">
	이름 : <input type="text" name="username"><br>
	비밀번호 : <input type="password" name="userpasswd"><br>
	<input type="hidden" name="logincnt" value=<%=logincnt%>><br>
	<input type="hidden" name="rtn_url" value=<%=rtn_url%>><br>
	<input type="submit" value="전송">
</form>
로그인 시도횟수 <%=logincnt%>회 입니다. <br>
rtn_url <%=rtn_url%> 입니다. <br>
</body>
</html>