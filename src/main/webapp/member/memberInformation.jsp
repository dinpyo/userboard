<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 세션 유효성 검사
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	// 로그인 되어 있으면 값을 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginMemberId + " <- memberInformation loginMemeberId");
	
	// DB 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	PreparedStatement memberInformationStmt = null;
	ResultSet memberInformationRs = null;
	
	// 결과셋(모델)
	String memberInformationSql = "SELECT member_id memberId, createdate, updatedate from member where member_id = ?";
	memberInformationStmt = conn.prepareStatement(memberInformationSql);
	memberInformationStmt.setString(1, loginMemberId);
	memberInformationRs = memberInformationStmt.executeQuery();
	System.out.println(memberInformationRs + "<-- memberInformation memberInformationRs");
	
	// Member 클래스 사용
	Member m = new Member();
	if (memberInformationRs.next()){
		m.setMemberId(memberInformationRs.getString("memberId"));
		m.setCreatedate(memberInformationRs.getString("createdate"));
		m.setUpdatedate(memberInformationRs.getString("updatedate"));
	}
	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 상세보기</title>
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
		<h1>회원 상세 정보</h1>
	</div>
	<br><br>
	<div style="text-align: center;">
		<table class="table table-bordered">
			<tr style="background-color: #DBC4F0;">
				<th>아이디</th>
				<th>생성일</th>
				<th>수정일</th>
			</tr>
			<tr style="background-color: white;">
				<td>
					<%=m.getMemberId()%>
				</td>
				<td>
					<%=m.getCreatedate()%>
				</td>
				<td>
					<%=m.getUpdatedate()%>
				</td>
			</tr>	
			<tr style="background-color: #DBC4F0;">
				<th>
					<a style="color: black;" href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">
						비밀번호 변경
					</a>
				</th>
				<td>&nbsp;</td>
				<th>
					<a style="color: black;" href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">
						회원탈퇴
					</a>
				</th>
			</tr>
		</table>
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