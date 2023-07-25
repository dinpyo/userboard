<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	// loginMemberId 세션 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// boardNo 요청값 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	} 
	
	//  commentContent 요청값 검사
	if(request.getParameter("commentContent") == null
		|| request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	} 
	
	// 불러온 값들 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String loginMemberId = request.getParameter("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + " <- insertCommentAction boardNo");
	System.out.println(loginMemberId + " <- insertCommentAction loginMemberId");
	System.out.println(commentContent + " <- insertCommentAction commentContent");

	// 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement Stmt = null;
	ResultSet rs = null;
	String sql = null;
	String Sql = "INSERT INTO COMMENT(board_no, comment_content, member_id, createdate, updatedate) value(?, ?, ?, NOW(), NOW())";
	Stmt = conn.prepareStatement(Sql);
	Stmt.setInt(1, boardNo);
	Stmt.setString(2, commentContent);
	Stmt.setString(3, loginMemberId);
	System.out.println(Stmt + " <- insertCommentAction Stmt");
	int row = Stmt.executeUpdate();
	System.out.println(row + " <- insertCommentAction row");
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);

%>