<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩
	response.setCharacterEncoding("utf-8");

	// 1. 컨트롤로 계층
	//유효성 검사
	int boardNo = 0;
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} else {
		boardNo = Integer.parseInt(request.getParameter("boardNo"));
		System.out.println("boardOne boardNo값을 받아옴");
	}
	
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	int rowPerPage = 5;
	int startRow = (currentPage-1)*rowPerPage;
	int totalRow = 0;

	// 2. 모델 계층
	// DB연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// board one 결과셋
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = null;
	boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	boardRs = boardStmt.executeQuery(); // row -> 1 -> Board타입
	
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	System.out.println(board + "<--boardOne board");
	
	// comment list 결과셋
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? LIMIT ?, ?";	
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	System.out.println(commentListStmt + "<-- boardOne commentListStmt");
	commentListRs = commentListStmt.executeQuery(); // row -> 최대10 -> ArrayList<Comment>
	// ArrayList로 바꾸기
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentListRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
	System.out.println(commentList + "<-- boardOne commentList");
	System.out.println(commentList.size() + "<-- boardOne commentList.size");
	
	// 페이징 결과셋
	PreparedStatement totalStmt = null;
	ResultSet totalRs = null;
	String totalRowSql = null;
	totalRowSql = "SELECT count(*) FROM comment WHERE board_no=?";
	totalStmt = conn.prepareStatement(totalRowSql);
	totalStmt.setInt(1,boardNo);
	totalRs = totalStmt.executeQuery();
	//디버깅
	System.out.println("totalStmt-->"+totalStmt);
	System.out.println("totalRs-->"+totalRs);
		
	//전체 페이지수를 구하고
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage=lastPage+1;
	}
	//페이지 넘기기 서포트
	String addPage = "";
	if(boardNo > 0) {
		addPage += "&boardNo=" + boardNo;
	}
	
	// 요청받은 메세지가 있으면 저장
	String msg = null;
	if (request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
		
	// 3. 뷰 계층
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
	<!-- 파비콘 설정-->
	<link rel="icon" href="<%=request.getContextPath()%>/img/userboard.png">
</head>
<body style="background-color: #FAF3F0;">
<div class="container">

	<!-- 메인메뉴(가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br><br><br><br>
	<!-- 3-1) board one 결과셋 -->
	<div>
		<h1>게시글 상세 정보</h1>
		<br>
	</div>
	<div style="text-align: center;">
		<!--  오류 메세지 표시 -->
		<%
			if(msg != null){
		%>
			<h3><%=msg%></h3>
		<%	
			}
		%>
		<br>
		<table class="table">
			<tr style="background-color: #DBC4F0;">
				<th>번호</th>
				<th>지역</th>
				<th>제목</th>
				<th style="width: 40%">게시글 내용</th>
				<th>아이디</th>
				<th>생성일</th>
				<th>수정일</th>
			</tr>
			<tr style="background-color: white;">
				<td><%=board.getBoardNo()%></td>
				<td><%=board.getLocalName()%></td>
				<td><%=board.getBoardTitle()%></td>
				<td><%=board.getBoardContent()%></td>
				<td><%=board.getMemberId()%></td>
				<td><%=board.getCreatedate().substring(0, 10)%></td>
				<td><%=board.getUpdatedate().substring(0, 10)%></td>
			</tr>
		</table>
		
		<% 
			// 게시물 작성자만 수정 삭제 가능
			if(session.getAttribute("loginMemberId") != null && session.getAttribute("loginMemberId").equals(board.getMemberId())) {
		    	String loginMemberId = (String)session.getAttribute("loginMemberId");
		%>
				<a style="background-color: #DBC4F0;" class="btn" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=board.getBoardNo() %>">수정</a>
		        <a style="background-color: #DBC4F0;" class="btn" href="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=board.getBoardNo() %>">삭제</a>         
		<%
			}
		%>
	</div>
	<br><br>
	<!-- 3-2) comment 입력 : 세션유무에 따른 분기 -->
	<div>
		<h1>댓글 등록</h1>
		<br>
	</div>
	<div style="text-align: center;">
	<%
		// 로그인 사용자만 댓글 입력 허용
		if(session.getAttribute("loginMemberId") != null) {
			// 현재 로그인 사용자의 아이디
			String loginMemberId = (String)session.getAttribute("loginMemberId");
	%>
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=boardNo%>">
				<input type="hidden" name="loginMemberId" value="<%=loginMemberId%>">		
				<table>
					<tr>
						<th>
							<textarea rows="2" cols="150" name="commentContent"></textarea>
						</th>
					</tr>
				</table>
				<br>
				<button style="background-color: #DBC4F0;" class="btn" type="submit">댓글입력</button>
			</form>
	<%		
		}
	%>
	</div>
	<br><br>
	<!-- 3-3) comment list 결과셋 -->
	<div>
		<h1>댓글 목록</h1>
		<br>
	</div>
	<div style="text-align: center;">
	<table class="table">
		<tr style="background-color: #DBC4F0;">
			<th style="width: 40%">댓글 내용</th>
			<th>아이디</th>
			<th>생성일</th>
			<th>수정일</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>	
		<%
			for(Comment c : commentList) {
		%>		
				<tr style="background-color: white;">
					<td><%=c.getCommentContent()%></td>	
					<td><%=c.getMemberId()%></td>	
					<td><%=c.getCreatedate()%></td>	
					<td><%=c.getUpdatedate()%></td>	
					<td><a style="color: black;" href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">수정</a></td>	
					<td><a style="color: black;" href="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">삭제</a></td>	
				</tr>	
		<%	
			}
		%>
	</table>
	</div>
	<br>
	
	<div style="text-align: center;">
		<%
			if(currentPage>1){
		%>
				<a style="background-color: #DBC4F0;" class="btn" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>&addPage=<%=addPage%>">이전</a>
		<%	
			}
		%>
				<a style="background-color: #DBC4F0;" class="btn" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&addPage=<%=addPage%>"><%=currentPage%></a>
		<%
			if(currentPage<lastPage){
		%>
				<a style="background-color: #DBC4F0;" class="btn" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>&addPage=<%=addPage%>">다음</a>
		<%
			}
		%>
	</div>
	<br><br>
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>	
	<br>
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</div>	
</body>
</html>