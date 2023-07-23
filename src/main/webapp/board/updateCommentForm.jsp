<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}	

	int commentNo= Integer.parseInt(request.getParameter("commentNo"));
	int boardNo= Integer.parseInt(request.getParameter("boardNo"));
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 수정</title>
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
		<h1>댓글 수정</h1>
	</div>
	<br><br>
	<div style="text-align: center;">
	<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp" method="post">
		<table class="table">
			<tr style="background-color: #DBC4F0;">
				<th>수정 할 내용</th>
				<td>
					<input type="text" name="commentContent" required="required">
				</td>
			</tr>
		</table>	
		<button style="background-color: #DBC4F0;" class="btn" type="submit">수정</button>
		
		<!-- boardNo와 commentNo값 보내기용 -->
        <input type="hidden" name="boardNo" value="<%=boardNo%>">
        <input type="hidden" name="commentNo" value="<%=commentNo%>">
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