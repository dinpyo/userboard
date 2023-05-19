<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
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
<title>회원가입</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body>
	<h1 class="text-center">회원 가입</h1>
	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<!--  오류 메세지 표시 -->
		<%
			if(msg != null){
		%>
			<%=msg%>
		<%	
			}
		%>
		<table class="table">
			<tr>
				<th>아이디</th>		
				<td><input type="text" name="memberId"></td>		
			</tr>
			<tr>
				<th>패스워드</th>		
				<td><input type ="password" name="memberPw"></td>		
			</tr>
		</table>
		<button type="submit">가입</button>
	</form>
	
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</body>
</html>