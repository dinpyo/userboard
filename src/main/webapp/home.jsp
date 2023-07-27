<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석(컨트롤러 계층)	
	// 1) session JSP내장(기본)객체
	
	// 2) request / response JSP내장(기본)객체
	
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startRow = (currentPage-1)*rowPerPage;
	int totalRow = 0;
	
	int pageCount = 10; //한번에 출력될 페이징 버튼 수(1,2,3,4--)
	// 1~10번을 눌러도 1~10페이지만 출력되도록 설정
	int startPage = ((currentPage - 1) / pageCount) * pageCount + 1; //페이징 버튼 시작 값
	int endPage = startPage + pageCount - 1; //페이징 버튼 종료 값
	
	// 2. 모델 계층
	// DB연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 1) 서브메뉴 결과셋(모델)
	/*
		SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION ALL 
		SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
	*/
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	subMenuRs = subMenuStmt.executeQuery();
	ArrayList<HashMap<String, Object>> subMenuList 
				= new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	// 2) 게시판 목록 결과셋(모델)
	/*
		SELECT 
			board_no boardNo,
			local_name localName,
			board_title boardTitle,
			createdate
		FROM board
		WHERE local_name = ?
		ORDER BY createdate DESC
		LIMIT ?, ?
	*/
	String localName = "전체";
	if(request.getParameter("localName") != null) {
		localName = request.getParameter("localName");
	}
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	
	String boardSql = "";
	if(localName.equals("전체")) {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, startRow);
		boardStmt.setInt(2, rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name = ? ORDER BY board_no DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
	}
	boardRs = boardStmt.executeQuery(); // DB쿼리 결과셋 모델
	ArrayList<Board> boardList = new ArrayList<Board>();// 애플케이션에서 사용할 모델(사이즈 0)
	// boardRs --> boardList

	while(boardRs.next()) {
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	System.out.println(boardList + " <--home boardList");
	System.out.println(boardList.size()+ " <--home boardList.size()");

	// 페이지의 전체 행 구하는 쿼리문
	String totalRowSql = null;
	PreparedStatement totalStmt = null;
	ResultSet totalRs = null;
	totalRowSql = "SELECT count(*) FROM board";
	totalStmt = conn.prepareStatement(totalRowSql);
	totalRs = totalStmt.executeQuery();
	System.out.println(totalStmt+ " <--totalStmt");
	System.out.println(totalRs+ "<--totalRs");
		
	// 전체 페이지수
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	
	// 마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage++;
	}
	
	int totalPage = (int) Math.ceil(totalRow / (double) rowPerPage); //출력할 전체 페이지 수
	
	// 추가로 조건 설정
	if(currentPage > totalPage){
		currentPage = totalPage;
	}
	
	if(endPage > totalPage){
		endPage = totalPage;
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 홈페이지</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body style="background-color: #FAF3F0;">
<div class="container">
	<div class="row">
		<!-- 메인메뉴(가로) -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include	>
		<br><br>
		
		<div style="text-align: center;">
			<h1>국내 여행 스토리</h1>
			<br>
		</div>
		<!-- 서브메뉴(세로) subMenuList모델을 출력 -->
		<div class="col-sm-2">	
			<div style="text-align: center;">
				<table class="table">
					<%
						for(HashMap<String, Object> m : subMenuList) {
					%>	
						<tr style="background-color: #DBC4F0;">	
							<td>					<!-- 자바문 (String),(Integer)생략가능 -->
								<a style="color: black;" href ="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
									<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a>
							</td>
						</tr>
					<%
						}
					%>
				</table>
			</div>
		</div>
		
		<div class="col-sm-6">
			<div style="text-align: center;">
				<img src="<%=request.getContextPath()%>/img/jido.jpg" width="540px" height="440px">
			</div>
		</div>
		
		<!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->	
		<div class="col-sm-4">
			<div style="text-align: center;">
				<!-- 로그인 폼 -->
				<%
					if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
				%>		
						<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
							<table class="table table-borderless">
								<tr style="background-color: #DBC4F0;">
									<th>아이디</th>
									<td><input type="text" name="memberId" value="admin" required="required"></td>
								</tr>
								<tr style="background-color: #DBC4F0;">
									<th>비밀번호</th>
									<td><input type="password" name="memberPw" value="1234" required="required"></td>
								</tr>
								<tr style="background-color: #DBC4F0;">
									<td colspan="2">
										<button type="submit" style="float:right;">로그인</button>
									</td>
								</tr>
							</table>
						</form>
						
						<div style="text-align: center; background-color: #DBC4F0;">
							<br>
							<h5>지역별 회원 전용 게시판 프로젝트 <br>
								기간 : 2023.05.02 ~ 2023.05.15 <br>
							</h5>
							<br>
							<ul>
								<li>Eclipse(2022-12(4.23.0), JDK(17.0.7) </li>
								<li>HTML5, CSS3, bootstrap5 </li>
								<li>Apache tomcat(10.1.11)</li>
								<li>Mariadb(10.5.19), HeidiSQL(11.3.0)</li>
					       </ul>
					       <br><br>
						</div>				
				<%	
					} else {
				%>
	     				<h2><%=session.getAttribute("loginMemberId")%>님 접속중</h2>
	     		<!-- 메인메뉴(가로) -->
				<!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
	    	 	<%
	        		}
	     		%>   
			</div>
			<br>	
		</div>
	</div>
	<br>	
		
	<!---[시작] boardList--------------------------------------------------->
	<div class="col-sm-13" style="text-align: center;">	
				<table class="table">
					<tr style="background-color: #DBC4F0;">
						<th>지역 이름</th>
						<th>글 제목</th>
						<th>생성일</th>
					</tr>
					<%
						for(Board b : boardList) {
					%>
							<tr style="background-color: white;">
								<td><%=b.getLocalName()%></td>
								<td> 
									<a style="color: black;" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
										<%=b.getBoardTitle()%>
									</a>
								</td>
								<td><%=b.getCreatedate().substring(0, 10)%></td>
							</tr>	
					<%
						}
					%>
					
		</table>		
	</div>
	<!---[끝]boardList--------------------------------------------------->
	<br>
	
	<div class="container mt-3">
		<ul class="pagination justify-content-center" style="margin:20px 0">
			<%
				// 이전 페이지 버튼
				if(currentPage > pageCount){
			%>
		   			<li class="page-item">
		   				<a class="page-link text-dark" style="background-color: #DBC4F0;" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-10%>&localName=<%=localName%>">
		   					이전
		   				</a>
		   			</li>
		   	<%
				}
		        for(int i = startPage; i <= endPage; i++){ //현재페이지
		        	if(i==currentPage){
		    %>
		        		<li class="page-item active">
		        			<a class="page-link text-dark" style="background-color: #DBC4F0;" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>">
		        				<%=i%>
		        			</a>
		        		</li>
		    <%
		        	}else{
		   	%>
		       		<li class="page-item">
		       			<a class="page-link text-dark" style="background-color: white;" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
		       				<%=i%>
		       			</a>
		       		</li>
				<%
		       		}
		        }
		    	// 다음 페이지 버튼
		    	if(currentPage < (lastPage-pageCount+1)){
				%>
				<li class="page-item">
					<a class="page-link text-dark" style="background-color: #DBC4F0;" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1%>&localName=<%=localName%>">
						다음
					</a>
				</li>
			<%
				}
			%>
		</ul>
	</div>
		
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>	
	<br>
</div>
</body>
</html>