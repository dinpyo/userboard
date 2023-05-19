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
<title>Insert title here</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
	<h1>지역 추가</h1>
	<form action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
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
				<th class="table-dark">지역이름</th>
				<td class="table-dark"><input type="text" name="localName"></td>
			</tr>	
		</table>
		<button type="submit">추가</button>
	</form>
	</div>
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</body>
</html>