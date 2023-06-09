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
	//1~10번을 눌러도 1~10페이지만 출력되도록 설정
	int startPage = ((currentPage - 1) / pageCount) * pageCount + 1; //페이징 버튼 시작 값
	int endPage = startPage + pageCount - 1; //페이징 버튼 종료 값
	
	// 2. 모델 계층
	// DB연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
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

	//페이지의 전체 행 구하는 쿼리문
	String totalRowSql = null;
	PreparedStatement totalStmt = null;
	ResultSet totalRs = null;
	totalRowSql = "SELECT count(*) FROM board";
	totalStmt = conn.prepareStatement(totalRowSql);
	totalRs = totalStmt.executeQuery();
	System.out.println(totalStmt+ " <--totalStmt");
	System.out.println(totalRs+ "<--totalRs");
		
	//전체 페이지수
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	
	//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
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
<title>Insert title here</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container">
<div class="row">
		<!-- 메인메뉴(가로) -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include	>
		</div>
	<div>
		<!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->	
			<!-- 로그인 폼 -->
			<%
				if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
			%>		
					<h6 style="text-align: center;">
						기간 : 2023.05.02 ~ 2023.05.15 <br> 
						사용 언어 : Java, HTML, CSS, MariaDB
					</h6>
					
					<div style=" margin: 0 5px; float:right;">
					<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
						<table class="table">
							<tr>
								<td class="table-dark">아이디</td>
								<td class="table-dark"><input type="text" name="memberId"></td>
							</tr>
							<tr>
								<td class="table-dark">패스워드</td>
								<td class="table-dark"><input type="password" name="memberPw"></td>
							</tr>
							<tr>
								<td colspan="2" class="table-dark">
									<button type="submit" style="float:right;">로그인</button>
								</td>
							</tr>
						</table>
					</form>
					
			<%	
				} else {
			 %>
     		<h2><%=session.getAttribute("loginMemberId")%>님</h2>
     		<!-- 메인메뉴(가로) -->
			<!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
    	 <%
        	}
     	%>   
	</div>
	
		<div class="col-sm-2 container" style=" margin: 0 5px; float:left: ;">	
		<!-- 서브메뉴(세로) subMenuList모델을 출력 -->
		<div style="margin-top: 32px; text-align: center;">
			<table class="table table-bordered">
				<%
				for(HashMap<String, Object> m : subMenuList) {
				%>	
					<tr class="table-info">	
						<td>													<!-- 자바문 (String),(Integer)생략가능 -->
							<a href ="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
								<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a>
						</td>
					</tr>
				<%
				}
				%>
			</table>
		</div>
		</div>
		</div>
		
		<!---[시작] boardList--------------------------------------------------->
<div class="col-sm-10">	
			<table class="table">
				<tr>
					<th class="table-dark">지역 이름</th>
					<th class="table-dark">글 제목</th>
					<th class="table-dark">생성일</th>
				</tr>
				<%
					for(Board b : boardList) {
				%>
						<tr class="table-info">
							<td><%=b.getLocalName()%></td>
							<td>
								<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
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
</div>
		
		<!---[끝]boardList--------------------------------------------------->
	<div class="container mt-3">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<%
			//이전 페이지 버튼
			if(currentPage > pageCount){
		%>
	   			<li class="page-item">
	   				<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-10 %>&localName=<%=localName%>">
	   					Previous
	   				</a>
	   			</li>
	   	<%
			}
	        for(int i = startPage; i <= endPage; i++){
	        	if(i==currentPage){
	    %>
	        		<li class="page-item active">
	        			<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
	        				<%=i %>
	        			</a>
	        		</li>
	    <%
	        	}else{
	   	%>
	       		<li class="page-item">
	       			<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
	       				<%=i %>
	       			</a>
	       		</li>
	       <%
	       		}
	        }
	    	//다음 페이지 버튼
	    	if(currentPage < (lastPage-pageCount+1)){
	       %>
			<li class="page-item">
				<a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1 %>&localName=<%=localName%>">
					Next
				</a>
			</li>
		<%
			}
		%>
	</ul>
	</div>
		
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
	
	
</div>	
</body>
</html>