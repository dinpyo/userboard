<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청받은 메세지가 있으면 저장
	String msg = null;
	if (request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지역 추가</title>
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
		<h1>지역 추가</h1>
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
		<form action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
			<table class="table">
				<tr style="background-color: #DBC4F0;">
					<th>지역이름</th>
					<td><input type="text" name="localName" required="required"></td>
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