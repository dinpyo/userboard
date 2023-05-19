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
<title>Insert title here</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
	<h1>댓글 수정</h1>
	<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp" method="post">
		<table class="table">
			<tr>
				<th class="table-info">수정할 내용 : </th>
				<td class="table-info">
					<input type="text" name="commentContent">
				</td>
			</tr>
			
		</table>	
		<button class="btn btn-primary" type="submit">수정</button>
		<!-- boardNo와 commentNo값 보내기용 -->
        <input type="hidden" name="boardNo" value="<%=boardNo%>">
        <input type="hidden" name="commentNo" value="<%=commentNo%>">
	</form>
	</div>
</body>
</html>