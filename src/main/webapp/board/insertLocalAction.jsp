<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import= "vo.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 메시지 담을 변수 선언
	String msg = null;

	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 요청값 유효성 검사
	if(request.getParameter("localName") == null			
		||request.getParameter("localName").equals("")){
		msg =  URLEncoder.encode("지역이름을 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}
	// 요청값 저장
	String localName = request.getParameter("localName");
	System.out.println(localName + "<-- insertLocalAction localName");
	
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 지역 생성(INSERT)
	PreparedStatement localStmt = null;
	String localSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, NOW(), NOW())";
	localStmt = conn.prepareStatement(localSql);
	localStmt.setString(1, localName);
	System.out.println(localStmt + "<-- insertLocalAction localStmt");
	int row = localStmt.executeUpdate();
	
	// 제대로 작동하는지 확인하기
	if(row == 1) {
		System.out.println("지역 추가 성공");
	} else {
		System.out.println("지역 추가 실패");
		response.sendRedirect(request.getContextPath() +"/board/insertLocalForm.jsp");
	}
	response.sendRedirect(request.getContextPath() +"/home.jsp");
%>