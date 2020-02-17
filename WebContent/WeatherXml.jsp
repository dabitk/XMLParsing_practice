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
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*" %>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%!
	String seq=""; //48시간중 몇번째 인지 가르킴
	String hour=""; //동네예보 3시간 단위
	String day=""; //1번째날 (0: 오늘/1: 내일/2: 모래)
	String temp=""; //현재 시간온도
	String tmx=""; //최고 온도
	String tmn=""; //최저 온도
	String sky=""; //하늘 상태코드 (1: 맑음, 2: 구름조금, 3: 구름많음, 4: 흐림)
	String pty=""; //강수 상태코드 (0: 없음, 1: 비, 2: 비/눈, 3: 눈/비, 4: 눈)
	String wfKor=""; //날씨 한국어
	String wfEn=""; //날씨 영어
	String pop=""; //강수 확률%
	String r12=""; //12시간 예상 강수량
	String s12=""; //12시간 예상 적설량
	String ws=""; //풍속(m/s)
	String wd=""; //풍속(0~7:북, 북동, 동, 남동, 남, 남서, 서, 북서)
	String wdKor=""; //풍향 한국어
	String wdEn=""; //습도 %
	String reh=""; //풍향 영어
	String r06=""; //6시간 예상 강수량
	String s06=""; //6시간

	DefaultHttpClient client;

	//HttpClient 재사용 관련 서버 통신시 세션을 유지 하기 위함
	//HttpClient 4.5.2 -> https://hc.apache.org/downloads.cgi
	
	public DefaultHttpClient getThreadSafeClient(){
		if(client != null)
			return client;
		
		client = new DefaultHttpClient();
		ClientConnectionManager mgr = client.getConnectionManager();
		HttpParams params = client.getParams();
		client = new DefaultHttpClient(new ThreadSafeClientConnManager(params, mgr.getSchemeRegistry()),params);
		
		return client;
	}	
	
	public String goXML(String getURL){
		return goXML(getURL, false);
	}
	public String goXML(String getURL, Boolean loginFlag){
		String Result = null;
		
		//세션유지 체크
		HttpClient client = getThreadSafeClient();
		
		HttpConnectionParams.setConnectionTimeout(client.getParams(),100000);
		HttpConnectionParams.setSoTimeout(client.getParams(),100000);
		HttpGet get = new HttpGet(getURL);
		
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
		if(loginFlag){ //여기가 post/get 패러미터를 전달하는 곳
			nameValuePairs.add(new BasicNameValuePair("username","kopoctc"));
			nameValuePairs.add(new BasicNameValuePair("userpasswd","kopoctc"));
		}
		
		try{
			//get.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			HttpResponse responsePost = null;
			
			responsePost = client.execute(get);
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
<style>
	.centered {
		text-align:center;
	}
</style>
</head>
<body>
<%
//로그인 후 xml을 조회한다. 내부소스에 이미 세션을 유지하도록 설계되어 있다.
String ret=null;
ret=goXML("https://www.kma.go.kr/wid/queryDFS.jsp?gridx=61&gridy=123");
//out.println(ret);

try{
	//DocumentBuilderFactory 객체 생성
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	//Documentbuilder 객체 생성
	DocumentBuilder builder = factory.newDocumentBuilder();
	
	ByteArrayInputStream is = new ByteArrayInputStream(ret.getBytes("utf-8"));
	//builder를 이용하여 XML 파싱하여 Document 객체 생성
	Document doc = builder.parse(is);
	
	//생성된 document에서 각 요소들을 접근하여 데이터를 저장함
	Element root = doc.getDocumentElement();
	NodeList tag_001 = doc.getElementsByTagName("data"); //xml data tag
	
	out.println("<table cellspacing='1' width='2000' border='1'");
	out.println("<tr>");
	out.println("<td width='100'>NO.</td>");
	out.println("<td width='100'>시간</td>");
	out.println("<td width='100'>날짜</td>");
	out.println("<td width='100'>현재온도</td>");
	out.println("<td width='100'>최고온도</td>");
	out.println("<td width='100'>최저온도</td>");
	out.println("<td width='100'>하늘</td>");
	out.println("<td width='100'>강수</td>");
	out.println("<td width='100'>날씨(KOR)</td>");
	out.println("<td width='100'>날씨(ENG)</td>");
	out.println("<td width='100'>강수확률</td>");
	out.println("<td width='100'>풍속(m/s)</td>");
	out.println("<td width='100'>풍향</td>");
	out.println("<td width='100'>풍향(KOR)</td>");
	out.println("<td width='100'>풍향(ENG)</td>");
	out.println("<td width='100'>습도(%)</td>");
	out.println("</tr>");
	
	for(int i=0;i<tag_001.getLength();i++){
		Element elmt = (Element)tag_001.item(i);
		
		seq=tag_001.item(i).getAttributes().getNamedItem("seq").getNodeValue();
		hour=elmt.getElementsByTagName("hour").item(0).getFirstChild().getNodeValue();
		day=elmt.getElementsByTagName("day").item(0).getFirstChild().getNodeValue();
		temp=elmt.getElementsByTagName("temp").item(0).getFirstChild().getNodeValue();
		tmx=elmt.getElementsByTagName("tmx").item(0).getFirstChild().getNodeValue();
		tmn=elmt.getElementsByTagName("tmn").item(0).getFirstChild().getNodeValue();
		sky=elmt.getElementsByTagName("sky").item(0).getFirstChild().getNodeValue();
		pty=elmt.getElementsByTagName("pty").item(0).getFirstChild().getNodeValue();
		wfKor=elmt.getElementsByTagName("wfKor").item(0).getFirstChild().getNodeValue();
		wfEn=elmt.getElementsByTagName("wfEn").item(0).getFirstChild().getNodeValue();
		pop=elmt.getElementsByTagName("pop").item(0).getFirstChild().getNodeValue();
		ws=elmt.getElementsByTagName("ws").item(0).getFirstChild().getNodeValue();
		wd=elmt.getElementsByTagName("wd").item(0).getFirstChild().getNodeValue();
		wdKor=elmt.getElementsByTagName("wdKor").item(0).getFirstChild().getNodeValue();
		wdEn=elmt.getElementsByTagName("wdEn").item(0).getFirstChild().getNodeValue();
		reh=elmt.getElementsByTagName("reh").item(0).getFirstChild().getNodeValue();
		
		//System.out.println(seq);
		//System.out.println(hour);
		//System.out.println(day);
		//System.out.println(temp);
		//System.out.println(tmx);
		//System.out.println(sky);
		//System.out.println(pty);
		//System.out.println(wfKor);
		//System.out.println(wfEn);
		//System.out.println(pop);
		//System.out.println(r12);
		//System.out.println(s12);
		//System.out.println(ws);
		//System.out.println(wd);
		//System.out.println(wdKor);
		//System.out.println(wdEn);
		//System.out.println(reh);
		//System.out.println(r06);
		//System.out.println(s06);
		

		
		//이하 각 레코드 출력
		out.println("<tr>");
		out.println("<td width='100'>"+seq+"</td>");
		out.println("<td width='100'>"+hour+"</td>");
		out.println("<td width='100'>"+day+"</td>");
		out.println("<td width='100'>"+temp+"</td>");
		out.println("<td width='100'>"+tmx+"</td>");
		out.println("<td width='100'>"+tmn+"</td>");
		switch(sky){
		case "1":
			out.println("<td class='centered' width='100'><img src='NB01.png'></td>");
			break;
		case "2":
			out.println("<td class='centered' width='100'><img src='NB02.png'></td>");
			break;
		case "3":
			out.println("<td class='centered' width='100'><img src='NB03.png'></td>");
			break;
		case "4":
			out.println("<td class='centered' width='100'><img src='NB04.png'></td>");
			break;
		}
		//out.println("<td width='100'>"+sky+"</td>");
		switch(pty){
		case "0":
			out.println("<td class='centered' width='100'><img src='NB01.png'></td>");
			break;
		case "1":
			out.println("<td class='centered' width='100'><img src='NB08.png'></td>");
			break;
		case "2":
			out.println("<td class='centered' width='100'><img src='NB12.png'></td>");
			break;
		case "3":
			out.println("<td class='centered' width='100'><img src='NB13.png'></td>");
			break;
		case "4":
			out.println("<td class='centered' width='100'><img src='NB11.png'></td>");
			break;
		}
		out.println("<td width='100'>"+wfKor+"</td>");
		out.println("<td width='100'>"+wfEn+"</td>");
		out.println("<td width='100'>"+pop+"</td>");
		//out.println("<td width='100'>"+r12+"</td>");
		//out.println("<td width='100'>"+s12+"</td>");
		out.println("<td width='100'>"+ws+"</td>");
		out.println("<td width='100'>"+wd+"</td>");
		out.println("<td width='100'>"+wdKor+"</td>");
		out.println("<td width='100'>"+wdEn+"</td>");
		out.println("<td width='100'>"+reh+"</td>");
		//out.println("<td width='100'>"+r06+"</td>");
		//out.println("<td width='100'>"+s06+"</td>");
		out.println("</tr>");
	}
	}catch(Exception e){
		e.printStackTrace();
	}
	out.println("</table>");
%>
</body>
</html>