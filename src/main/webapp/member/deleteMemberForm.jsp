<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	System.out.println(loginMemberId + " <- deleteMemberForm loginMemeberId");
	
	// 요청받은 메시지 저장
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
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
		<h1>&nbsp; 회원탈퇴 &nbsp;</h1>
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
	
	<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post" id="submit">
		<table class="table table-bordered">
			<tr style="background-color: #DBC4F0;">
				<th>접속중인 아이디</th>
				<td>
					<%=loginMemberId%>
				</td>
			</tr>
			<tr style="background-color: #DBC4F0;">
				<th>비밀번호 입력</th>
				<td>
					<input type="password" name="password" required="required">
				</td>
			</tr>
		</table>
	</form>
	<br>
	<form action="<%=request.getContextPath()%>/member/memberInformation.jsp" method="post" id="cancle"></form>
	<button style="background-color: #DBC4F0;" type="submit" form="submit">탈퇴</button>
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