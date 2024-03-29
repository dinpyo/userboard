<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="vo.*" %>
<%	
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null				
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp?");
		return;
	}
	
	// 요청값을 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo + " <-- updateBoardForm boardNo");

	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	// SELECT board_no
	String sql="SELECT board_no, local_name, board_title, board_content, member_id, createdate, updatedate FROM board WHERE board_no=?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()){
		board = new Board();
	    board.setBoardNo(rs.getInt("board_no"));
	    board.setLocalName(rs.getString("local_name"));
	    board.setBoardTitle(rs.getString("board_title"));
	    board.setBoardContent(rs.getString("board_content"));
	    board.setMemberId(rs.getString("member_id"));
	}
	   
	String selSql="SELECT local_name FROM local";
	PreparedStatement selStmt = conn.prepareStatement(selSql);
	ResultSet selRs = selStmt.executeQuery();
	   
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while(selRs.next()){
		Local local = new Local();
		local.setLocalName(selRs.getString("local_name"));
		localNameList.add(local);
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
	<!-- 파비콘 설정-->
	<link rel="icon" href="<%=request.getContextPath()%>/img/userboard.png">
</head>
<body style="background-color: #FAF3F0;">
<div class="container">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br><br><br>
	<div class="text-center">
		<h1>게시글 수정</h1>
	</div>
	<br><br>
	<div style="text-align: center;">
	<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
		<table class="table">
			<tr style="background-color: #DBC4F0;">
				<th>번호</th>
				<td>
					<input type="number" name="boardNo" readonly="readonly" value="<%=board.getBoardNo()%>">
				</td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>아이디</th>
				<td>
					<input type="text" name="memberId" readonly="readonly" value="<%=loginMemberId%>">
				</td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>지역 이름</th>
				<td>
					<select name="localName">
						<%
							for(Local local : localNameList){
						%>
								<option value="<%=local.getLocalName()%>"><%=local.getLocalName()%></option>
						<%
							}
						%>
					</select>
				</td>
			</tr >
			<tr style="background-color: #DBC4F0;">
				<th>게시글 제목</th>
				<td>
					<input type="text" name="boardTitle" value="<%=board.getBoardTitle()%>" required="required">
				</td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>게시글 내용</th>
				<td>
					<input type="text" name="boardContent" value="<%=board.getBoardContent()%>" required="required">
				</td>
			</tr>
		</table>
		<button style="background-color: #DBC4F0;" class="btn" type="submit">수정</button>
	</form>
	</div>
</div>      
</body>
</html>