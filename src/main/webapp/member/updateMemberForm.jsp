<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	//세션 유효성 검사
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	// 로그인 되어 있으면 값을 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginMemberId + " <- updateMemberForm loginMemeberId");
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	// DB 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	PreparedStatement updateMemberStmt = null;
	ResultSet updateMemberRs = null;
	// 결과셋(모델)
	String updateMemberSql = "SELECT member_id memberId, createdate, updatedate from member where member_id = ?";
	updateMemberStmt = conn.prepareStatement(updateMemberSql);
	updateMemberStmt.setString(1, loginMemberId);
	updateMemberRs = updateMemberStmt.executeQuery();
	System.out.println(updateMemberRs + "<-- updateMemberForm updateMemberRs");
	Member m = new Member();
	if (updateMemberRs.next()){
		m.setMemberId(updateMemberRs.getString("memberId"));
		m.setCreatedate(updateMemberRs.getString("createdate"));
		m.setUpdatedate(updateMemberRs.getString("updatedate"));
	}
	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀변호 변경</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body style="background-color: #FAF3F0;">
<div class="container">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br><br><br>
	<div class="text-center">
		<h1>&nbsp; 비밀번호 변경 &nbsp;</h1>
		<br>
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
	</div>	
	<br><br>
	<div style="text-align: center;">
		<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" method="post" id="submit">
			<table class="table table-bordered">
				<tr style="background-color: #DBC4F0;">
					<th>접속중인 아이디</th>
					<td><%=m.getMemberId()%></td>
				</tr>
				<tr style="background-color: #DBC4F0;">
					<th>현재 비밀번호 입력</th>
					<td>
						<input type="password" name="currentPassword">
					</td>
				</tr>
				<tr style="background-color: #DBC4F0;">
					<th>새로운 비밀번호 입력</th>
					<td>
						<input type="password" name="newPassword">
					</td>
				</tr>
				<tr style="background-color: #DBC4F0;">
					<th>새로운 비밀번호 확인</th>
					<td>
						<input type="password" name="newPasswordCheck">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<br>
	<div style="text-align: center;">
		<form action="<%=request.getContextPath()%>/member/memberInformation.jsp" method="post" id="cancle"></form>
			<button style="background-color: #DBC4F0;" type="submit" form="submit">수정</button>
			<button style="background-color: #DBC4F0;" type="submit" form="cancle">취소</button>
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