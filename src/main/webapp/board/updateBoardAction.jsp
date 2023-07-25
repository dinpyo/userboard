<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%
	// 1.컨트롤러 계층
	// 인코딩
	request.setCharacterEncoding("utf-8");
	// 요청값중 null이거나 공백이 있으면 게시글 추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("boardTitle") == null
		|| request.getParameter("boardContent") == null
		|| request.getParameter("boardNo") == null
		|| request.getParameter("localName") == null
		|| request.getParameter("boardTitle").equals("")
		|| request.getParameter("boardContent").equals("")
		|| request.getParameter("localName").equals("")
		|| request.getParameter("boardNo").equals("")){
		msg = URLEncoder.encode("수정할값을 전부 입력하지 않았습니다..", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg);
		return;
	}
   
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String localName = request.getParameter("localName");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
   
	// 요청값 디버깅 
	System.out.println(boardTitle + " <--- updateBoardAction boardTitle");
	System.out.println(boardContent + " <--- updateBoardAction boardContent");
	System.out.println(boardNo + " <--- updateBoardAction boardNo");
   
	// 2.모델 계층
    //db 연동
    String driver = "org.mariadb.jdbc.Driver";
    String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
    String dbuser = "root";
    String dbpw = "java1234";
    Class.forName(driver);
    Connection conn = null;
    
	// 1) 서브메뉴 결과셋(모델)
    //동적쿼리를위한 변수 
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    conn = DriverManager.getConnection(dburl, dbuser, dbpw);
    System.out.println( "드라이버 실행 <--- updateBoardAction");   
       
    /* 수정 쿼리
       UPDATE board set member_id = ?, local_name = ?, board_title = ?, board_content = ?, createdate = now(), updatedate = now()
   */
	sql = "UPDATE board set local_name = ?, board_title = ?, board_content = ?, createdate = now(), updatedate = now() WHERE board_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setInt(4, boardNo );
	int row = stmt.executeUpdate();
      
    // 디버깅
	System.out.println(stmt + "<--- updateBoard stmt");
	System.out.println(row + "<--- updateBoard row");
      
	// row값 1이면 성공 0이면 실패
	if(row == 1){
		System.out.println("수정 완료");
		response.sendRedirect(request.getContextPath() +"/home.jsp");
	} else{
		System.out.println("수정 실패");
		msg = URLEncoder.encode("수정되지 않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg);
     }
%>