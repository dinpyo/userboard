<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%
	// 로그인 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}

	// 유효성검사
	if(request.getParameter("commentNo") == null
		||request.getParameter("boardNo") == null
		||request.getParameter("commentNo").equals("") 
		||request.getParameter("boardNo").equals("")) {
		
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		System.out.println("유효성 검사 실패");
		return;
	}
		
	// 받아온 값 변수에 저장
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);

	// DELETE 쿼리
	String deleteCommentSql = "DELETE FROM comment WHERE comment_no=?";
	stmt = conn.prepareStatement(deleteCommentSql);
	stmt.setInt(1, commentNo);
	System.out.println(stmt + " <-- deleteCommentAction stmt");
	int row = stmt.executeUpdate();

	if(row==1){
		String msg = URLEncoder.encode("댓글이 삭제되었습니다","utf-8");
	    response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
	    System.out.println("row값 정상");
	    return;
	}else{
	    String msg = URLEncoder.encode("댓글 삭제에 실패하였습니다","utf-8");
	    response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
	    System.out.println("row값 오류");
	    return;
	}



%>