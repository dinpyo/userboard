<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import= "vo.*" %>
<% 
	//1.컨트롤러 계층
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 요청값중 null이거나 공백이 있으면 게시글 추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("localName") == null
		|| request.getParameter("boardTitle") == null
		|| request.getParameter("boardContent") == null
		|| request.getParameter("memberId") == null
		|| request.getParameter("localName").equals("") 
		|| request.getParameter("boardTitle").equals("")
		|| request.getParameter("boardContent").equals("")
		|| request.getParameter("memberId").equals("")){
		msg = URLEncoder.encode("값을 전부 입력하지 않았습니다..", "utf-8");
	    response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
	    return;
	}
	
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String memberId = request.getParameter("memberId");
	
	// 요청값 디버깅 
	System.out.println(localName + " <--- insertBoardAction localName");
	System.out.println(boardTitle + " <--- insertBoardAction boardTitle");
	System.out.println(boardContent + " <--- insertBoardAction boardContent");
	System.out.println(memberId + " <--- insertBoardAction memberId");
	
	// 2.모델 계층
    //db 연동
    String driver = "org.mariadb.jdbc.Driver";
    String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
    String dbuser = "root";
    String dbpw = "java1234";
    // db연동 변수 
    Class.forName(driver);
    Connection conn = null;
    // 1) 서브메뉴 결과셋(모델)
    //동적쿼리를위한 변수 
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    conn = DriverManager.getConnection(dburl, dbuser, dbpw);
    System.out.println( "드라이버 실행 <--- insertBoardAction");	
    
    /* 추가 쿼리
    	INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) 
    	VALUES (?, ?, ?, ?, now(), now())
    */
    sql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES (?, ?, ?, ?, now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, memberId);
	int row = stmt.executeUpdate();
	
	System.out.println(stmt + "<--- insertBoardAction stmt ");
	System.out.println(row + "<--- insertBoardAction row ");
	
	// 성공시 홈으로 실패시 카테고리 추가폼으로
	if(row == 1) {
		System.out.println("게시글 추가 완료 <--- insertBoardAction");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println("게시글 추가 실패 <--- insertBoardAction");
		msg = URLEncoder.encode("게시글이 추가되지 않았습니다 다시시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
	}
	
%>