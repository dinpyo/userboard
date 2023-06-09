<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn + "접속성공");
	
	// local 전체 조회 (SELECT)
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName, createdate, updatedate FROM local;";
	localStmt = conn.prepareStatement(localSql);
	System.out.println(localStmt + " <-- selectLocal localStmt");
	localRs = localStmt.executeQuery();
	// ArrayList로 변환
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()) {
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		l.setUpdatedate(localRs.getString("updatedate"));
		localList.add(l);
	}
	System.out.println(localList + "<--selectLocal localList");
	System.out.println(localList.size() + "<--selectLocal localList.size()");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지역 목록</title>	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴(가로) -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<br>
		<h1 class="text-center">지역 목록</h1>
		<table class="table">
			<tr>
				<th class="table-dark">지역명</th>
				<th class="table-dark">수정</th>
				<th class="table-dark">삭제</th>
			</tr>
			<%
				for(Local l : localList) {
			%>
					<tr class="table-info">
						<td>
							<%=l.getLocalName()%>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/board/updateLocalForm.jsp?localName=<%=l.getLocalName()%>">수정</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/board/deleteLocalAction.jsp?localName=<%=l.getLocalName()%>">삭제</a>
						</td>
					</tr>
			<%		
				}
			%>
		</table>
		<a href="<%=request.getContextPath()%>/board/insertLocalForm.jsp">지역 추가</a>
	</div>
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</body>
</html>