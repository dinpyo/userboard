<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "java.net.*" %>
<%@ page import="vo.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 요청값 유효성 검사
	if(request.getParameter("memberId") == null			
		||request.getParameter("memberPw") == null
		||request.getParameter("memberId").equals("")
		||request.getParameter("memberPw").equals("")){			
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId + "<-- insertMemberAction memberId");
	System.out.println(memberPw + "<-- insertMemberAction memberPw");
	
	// 요청값을 객체에 저장
	Member newMember = new Member();
	newMember.setMemberId(memberId);
	newMember.setMemberPw(memberPw);

	// db 연결에 쓸 변수 생성
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	// db 연결
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	ResultSet rs = null;
	PreparedStatement stmt= null;
	
	// 아이디 중복확인 (SELECT)
	String sql = "SELECT member_id from member where member_id = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newMember.getMemberId());
	System.out.println(stmt + "<-- insertMemberAction stmt");
	rs = stmt.executeQuery();
	if(rs.next()){
		String msg = URLEncoder.encode("사용중인 ID입니다.", "utf-8");
		System.out.println("사용중인 ID");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// 회원가입 아이디생성(INSERT)
	String sql2 = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, newMember.getMemberId());
	stmt2.setString(2, newMember.getMemberPw());
	System.out.println(stmt2 + "<-- insertMemberAction stmt2");
	int row = stmt2.executeUpdate();
	
	// 제대로 작동하는지 확인하기
	if(row == 1) {
		System.out.println("회원가입 성공");
	} else {
		System.out.println("회원가입 실패");
	}
	
	response.sendRedirect(request.getContextPath() +"/home.jsp");
	
%>