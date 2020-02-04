<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h1>성적 조회 (kopo02 2020.02.04 실습완료)</h1>
<%
	//파싱을 위한 준비과정. DocumentBuilder는 XML문서로부터 DOM 객체를 읽어오는데 사용하는 API임.
	//DOM파서라고도 한다.
	DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();

	//당연히 파일을 읽을때 서버내부 local path(전체경로)로 지정 ... 이 문장이 xml 파싱을 한다. 단 위에 xml 관련 임포트를 주의하자.
	Document doc = docBuilder.parse(new File("C:\\Users\\kopo02\\testdata.xml"));

	Element root = doc.getDocumentElement(); //root태그를 가져오기도 하지만 이 소스에서는 쓰이는 곳이 없다.
	//XML문서로부터 트리구조의 객체를 가져오는데, 각 태그를 하나의 노드로 볼 수 있음.
	//NodeList는 해당 페이지 안의 모든 노드를 포함하는 객체임. 
	NodeList tag_name = doc.getElementsByTagName("name"); //xml name tag
	//name이라는 태그로 구성된 모든 노드를 tag_name 노드리스트에 적재함
	NodeList tag_studentid = doc.getElementsByTagName("studentid"); //xml studentid tag
	//studentid이라는 태그로 구성된 모든 노드를 tag_studentid 노드리스트에 적재함
	NodeList tag_kor = doc.getElementsByTagName("kor");	//xml kor tag
	//kor이라는 태그로 구성된 모든 노드를 tag_kor 노드리스트에 적재함
	NodeList tag_eng = doc.getElementsByTagName("eng");	//xml eng tag
	//eng이라는 태그로 구성된 모든 노드를 tag_eng 노드리스트에 적재함
	NodeList tag_mat = doc.getElementsByTagName("mat");	//xml mat tag
	//mat이라는 태그로 구성된 모든 노드를 tag_mat 노드리스트에 적재함
	
	out.println("<table cellspacing=1 width=500 border=1>");
	out.println("<tr>");
	out.println("<td width=100>이름</td>");
	out.println("<td width=100>학번</td>");
	out.println("<td width=100>국어</td>");
	out.println("<td width=100>영어</td>");
	out.println("<td width=100>수학</td>");
	out.println("</tr>");
	
	for(int i=0;i<tag_name.getLength(); i++){
		//tag_name이라는 NodeList에 들어있는 데이터 수만큼 루프를 돌린다.
		//참고로 모든 태그리스트는 동일한 개수의 데이터가 들어있기 때문에
		//tag_name의 길이만큼만 루프를 돌려도 모든 리스트를 전부 출력할 수가 있다.
		out.println("<tr>");
		//아래와 같은 형식으로 불러온다..
		out.println("<td width=100>"+tag_name.item(i).getFirstChild().getNodeValue()+"</td>");		//.getFirstChild()가 없으면 null이 나온다
		out.println("<td width=100>"+tag_studentid.item(i).getFirstChild().getNodeValue()+"</td>");
		out.println("<td width=100>"+tag_kor.item(i).getFirstChild().getNodeValue()+"</td>");
		out.println("<td width=100>"+tag_eng.item(i).getFirstChild().getNodeValue()+"</td>");
		out.println("<td width=100>"+tag_mat.item(i).getFirstChild().getNodeValue()+"</td>");
		out.println("</tr>");
	}
%>
</body>
</html>