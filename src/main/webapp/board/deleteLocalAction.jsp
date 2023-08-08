<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import = "java.net.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}
	// 요청값 유효성 검사
	if(request.getParameter("localName") == null				
		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
		return;
	}
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- deleteLocalAction localName");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//  해당하는 localName의 개수(SELECT)
	PreparedStatement boardCkStmt = null;
	ResultSet boardCklRs = null;
	String boardCkSql = "SELECT COUNT(local_name) cnt FROM board WHERE local_name = ?";
	boardCkStmt = conn.prepareStatement(boardCkSql);
	boardCkStmt.setString(1, localName);
	System.out.println(boardCkStmt + " <-- updateLocalForm localStmt");

	boardCklRs = boardCkStmt.executeQuery();
	
	// 중복 검사
	int cnt = 0;
	if(boardCklRs.next()) {
		cnt = boardCklRs.getInt("cnt");
	}
	if (cnt != 0) {		// 해당 지역에 게시글이 있으면 selectLocal.jsp로
		String msg = URLEncoder.encode("게시글이 있어 삭제 할 수 없습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp?msg="+msg);
		return;
	}
	// localName 삭제(DELETE)
	PreparedStatement deleteLocalStmt = null;
	String deleteLocalSql = "DELETE FROM local WHERE local_name = ?";
	deleteLocalStmt = conn.prepareStatement(deleteLocalSql);
	deleteLocalStmt.setString(1, localName);
	System.out.println(deleteLocalStmt + " <-- deleteLocalAction localStmt");
	
	int row = deleteLocalStmt.executeUpdate();
	
	if(row == 1){ // 지역이름 삭제 성공
		System.out.println("지역이름 삭제 성공");
	} else { 	
		System.out.println("지역이름 삭제 실패"); 
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>