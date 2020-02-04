<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="org.apache.http.HttpEntity" %>
<%@ page import="org.apache.http.HttpResponse" %>  
<%@ page import="org.apache.http.NameValuePair" %>  
<%@ page import="org.apache.http.ParseException" %>  
<%@ page import="org.apache.http.client.HttpClient" %>  
<%@ page import="org.apache.http.client.entity.UrlEncodedFormEntity" %>  
<%@ page import="org.apache.http.client.methods.HttpGet" %>  
<%@ page import="org.apache.http.client.methods.HttpPost" %>  
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>  
<%@ page import="org.apache.http.message.BasicNameValuePair" %>  
<%@ page import="org.apache.http.params.HttpConnectionParams" %>  
<%@ page import="org.apache.http.util.EntityUtils" %>  
<%@ page import="org.apache.http.conn.ClientConnectionManager" %>  
<%@ page import="org.apache.http.params.HttpParams" %>  
<%@ page import="org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager" %>  
<%@ page import="java.io.*" %>  
<%@ page import="java.text.*,java.util.*,java.sql.*,javax.servlet.*,javax.sql.*,javax.naming.*" %>  
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*"%>  

    
<!DOCTYPE html>
<html>
<head>
<%!
	DefaultHttpClient client;

	/**
	* HttpClient 재사용 관련 서버 통신시 세션을 유지 하기 위함... HttpClient 4.5.11 -> https://hc.apache.org/downloads.cgi
	*/
	
	public DefaultHttpClient getThreadSafeClient(){
		//마치 브라우저로 조회하여 세션이 유지되는 효과를 얻음
		if(client != null)
			return client;
		client = new DefaultHttpClient();
		ClientConnectionManager mgr = client.getConnectionManager();
		HttpParams params = client.getParams();
		client = new DefaultHttpClient(new ThreadSafeClientConnManager (params, mgr.getSchemeRegistry()), params);
		return client;
	}
	public String goXML(String getURL){
		//해당 URL 주소를 입력하여 xml 파일 (문자열 형태) 을 리턴 받는 함수
		String Result = null;
		//세션유지 체크
		HttpClient client = getThreadSafeClient();
		HttpConnectionParams.setConnectionTimeout(client.getParams(),100000);
		HttpConnectionParams.setSoTimeout(client.getParams(), 100000);
		HttpPost post = new HttpPost(getURL);
		
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
		if(false){ //여기가 post/get 패러미터를 전달하는 곳
			nameValuePairs.add(new BasicNameValuePair("input1", "kopoctc"));
		}
		try{
			post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			HttpResponse responsePost = null;
			
			responsePost = client.execute(post);
			HttpEntity resEntity = responsePost.getEntity();
			
			if(resEntity != null){
				Result = EntityUtils.toString(resEntity).trim();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			
		}
		
		return Result;
	}

%>
</head>
<body>
<%
	String ret=goXML("http://192.168.23.14:8080/testdata.jsp");
	//out.println(ret);
	
	try{
		//DocumentBuilderFactory 객체 생성
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		//DocumentBuilder 객체 생성
		DocumentBuilder builder = factory.newDocumentBuilder();
		
		ByteArrayInputStream is = new ByteArrayInputStream(ret.getBytes("utf-8"));
		//builder를 이용하여 XML 파싱하여 Document 객체 생성
		Document doc = builder.parse(is);
		
		//생성된 document에서 각 요소들을 접근하여 데이터를 저장함
		Element root = doc.getDocumentElement();
		NodeList tag_name = doc.getElementsByTagName("name"); //xml name tag
		NodeList tag_studentid = doc.getElementsByTagName("studentid"); //xml studentid tag
		NodeList tag_kor = doc.getElementsByTagName("kor"); //xml kor tag
		NodeList tag_eng = doc.getElementsByTagName("eng"); //xml eng tag
		NodeList tag_mat = doc.getElementsByTagName("mat"); //xml mat tag
		
		out.println("<table cellspacing=1 width=500 border=1>");
		out.println("<tr>");
		out.println("<td width=100>이름</td>");
		out.println("<td width=100>학번</td>");
		out.println("<td width=100>국어</td>");
		out.println("<td width=100>영어</td>");
		out.println("<td width=100>수학</td>");
		out.println("</tr>");
		for(int i=0;i<tag_name.getLength();i++){
			out.println("<tr>");
			out.println("<td width=100>"+tag_name.item(i).getFirstChild().getNodeValue()+"</td>");
			out.println("<td width=100>"+tag_studentid.item(i).getFirstChild().getNodeValue()+"</td>");
			out.println("<td width=100>"+tag_kor.item(i).getFirstChild().getNodeValue()+"</td>");
			out.println("<td width=100>"+tag_eng.item(i).getFirstChild().getNodeValue()+"</td>");
			out.println("<td width=100>"+tag_mat.item(i).getFirstChild().getNodeValue()+"</td>");
			out.println("</tr>");
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
</body>
</html>