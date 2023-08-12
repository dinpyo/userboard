<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import = "java.net.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청값 유효성 검사
	if(request.getParameter("localName") == null				
		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
		return;
	}
	
	// 요청값을 변수에 저장
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- updateLocalForm localName");
	
	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 해당하는 localName의 개수(SELECT)
	PreparedStatement boardCnkStmt = null;
	ResultSet boardCklRs = null;
	String boardCnkSql = "SELECT COUNT(local_name) cnt FROM board WHERE local_name = ?";
	boardCnkStmt = conn.prepareStatement(boardCnkSql);
	boardCnkStmt.setString(1, localName);
	System.out.println(boardCnkStmt + " <-- updateLocalForm boardCnkStmt");
	
	boardCklRs = boardCnkStmt.executeQuery();
	
	// 중복검사
	int cnt = 0;
	if(boardCklRs.next()) {
		cnt = boardCklRs.getInt("cnt");
	}
	if (cnt != 0) {		// 해당 지역에 게시글이 있으면 다시 selectLocal.jsp로
		String msg = URLEncoder.encode("게시글이 있어 수정할 수 없습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp?msg="+msg);
		return;
	}
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지역 수정</title>
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
		<h1>지역 수정</h1>
	</div>
	<br><br>
	<div>
		<h3>
			<%
				if(msg != null){
			%>
				<%=msg%>
			<%	
				}
			%>
		</h3>
	</div>
	<div style="text-align: center;">
		<form action="<%=request.getContextPath()%>/board/updateLocalAction.jsp" method="post">
			<table class="table">
				<tr style="background-color: #DBC4F0;">
					<th>현재 지역명</th>
					<td>
						<%=localName%>
						<input type="hidden" name="oldLocalName" value="<%=localName%>">
					</td>
				</tr>
				<tr style="background-color: #DBC4F0;">
					<th>새로운 지역</th>
					<td>
						<input type="text" name="localName" required="required">
					</td>
				</tr>
			</table>
			<button style="background-color: #DBC4F0;" class="btn" type="submit">수정</button>
		</form>
	</div>	
	<br><br><br><br><br><br><br>	
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</div>
</body>
</html>