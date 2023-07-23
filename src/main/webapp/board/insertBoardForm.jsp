<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 로그인 유효성검사& 에러메시지 변수
	String msg = URLEncoder.encode(".", "utf-8");
	if(session.getAttribute("loginMemberId") == null) {
		msg = "로그인이 되어있지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	// 로그인 되어있을시 아이디값 가져옴
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println("게시글 추가창 <--- insertBoardForm");
	
	//모델 계층
	// db 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// db연동 변수 
	Class.forName(driver);
	Connection conn = null;
	// 서브메뉴 결과셋(모델)
	// 동적쿼리를위한 변수 
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/* 쿼리	//게시글을 추가시킬 지역을 선택하기위한 쿼리
		SELECT local_name FROM local
	*/
	sql="SELECT local_name localName FROM local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()){
		Local l = new Local();
		l.setLocalName(rs.getString("localName"));
		localList.add(l);
	}
	
	// 디버깅
	System.out.println(localList + " <- insertBoardForm localList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 추가</title>
</head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body style="background-color: #FAF3F0;">
<div class="container">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br><br><br>
	<div class="text-center">
		<h1>게시글 추가</h1>
	</div>
	<br><br>
	<div style="text-align: center;">
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
		<table class="table table-bordered">
			<tr style="background-color: #DBC4F0;">
				<th>지역 이름</th>
				<td>
					<select name="localName">
						<%
							for(Local l : localList){
						%>
								<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
						<% 	
							}
						%>
					</select>
				</td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>게시글 제목</th>
				<td><input type="text" name="boardTitle" required="required"></td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>게시글 내용</th>
				<td><input type="text" name="boardContent" required="required"></td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>아이디</th>
				<td><input type="text" name="memberId" value="<%=memberId%>" readonly="readonly"></td>
			</tr>
		</table>
		<button style="background-color: #DBC4F0;" class="btn" type="submit">추가</button>
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