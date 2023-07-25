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
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	int row = 0;
	
	// 지역 조회(SELECT)
	PreparedStatement localSelectStmt = null;
	ResultSet localRs = null;
	String localSelectSql = "SELECT COUNT(*) FROM local WHERE local_name = ?";
	localSelectStmt = conn.prepareStatement(localSelectSql);
	localSelectStmt.setString(1, localName);
	localRs = localSelectStmt.executeQuery();
	if(localRs.next()) {
		row = localRs.getInt(1);
	}
	
	if(row > 0) {
		System.out.println("지역 추가 실패");
		msg =  URLEncoder.encode("이미 등록된 지역입니다.", "utf-8");
		response.sendRedirect(request.getContextPath() +"/board/insertLocalForm.jsp?msg="+msg);
		return;	
	} else {
		// 지역 생성(INSERT)
		PreparedStatement localInsertStmt = null;
		String localInsertSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, NOW(), NOW())";
		localInsertStmt = conn.prepareStatement(localInsertSql);
		localInsertStmt.setString(1, localName);
		System.out.println(localInsertStmt + "<-- insertLocalAction localStmt");
		row = localInsertStmt.executeUpdate();
		
		System.out.println("지역 추가 성공");
		response.sendRedirect(request.getContextPath() +"/home.jsp");
		return;
	}
	
%>