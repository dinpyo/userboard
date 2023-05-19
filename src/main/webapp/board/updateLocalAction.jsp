<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청값 유효성 검사
	if(request.getParameter("oldLocalName") == null				
		|| request.getParameter("oldLocalName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
		return;
	}
	
	// 요청값 변수에 저장
	String oldLocalName = request.getParameter("oldLocalName");
	
	// 요청값 유효성 검사
	if(request.getParameter("localName") == null				
			|| request.getParameter("localName").equals("")) {
			response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+oldLocalName);
			return;
	}
	
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- updateLocalAction localName");
	
	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 지역 이름 수정(UPDATE)
	PreparedStatement updateLocalStmt = null;
	String updateLocalSql = "UPDATE local SET local_name = ?, updatedate = NOW() WHERE local_name = ?";
	updateLocalStmt = conn.prepareStatement(updateLocalSql);
	updateLocalStmt.setString(1, localName);
	updateLocalStmt.setString(2, oldLocalName);
	System.out.println(updateLocalStmt + " <-- updateLocalAction localStmt");
	
	// 실행 결과
	int row = updateLocalStmt.executeUpdate();
	if(row == 1){ 
		System.out.println("지역이름 수정 성공");
	} else { 
		System.out.println("지역이름 수정 실패"); 
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+oldLocalName);
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>