<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
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
	System.out.println(loginMemberId + " <- updateMemberAction loginMemeberId");
	
	// 요청값중 null이거나 공백이 있으면 다시 수정폼으로
	String currentPassword = request.getParameter("currentPassword");
	String newPassword = request.getParameter("newPassword");
	String newPasswordCheck = request.getParameter("newPasswordCheck");
	System.out.println(currentPassword + " <- updateMemberAction currentPassword");
	System.out.println(newPassword + " <- updateMemberAction newPassword");
	System.out.println(newPasswordCheck + " <- updateMemberAction newPasswordCheck");
	
	// 요청 값이 공백이면 메세지 저장하고 다시 폼으로
	if ("".equals(request.getParameter("currentPassword"))){
		String msg = URLEncoder.encode("비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	} else if ("".equals(request.getParameter("newPassword"))){
		String msg = URLEncoder.encode("새로운 비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	// 입력값과 요청값이 같으면 메세지 저장하고 다시 폼으로 
	if (currentPassword.equals(newPassword)) {
		String msg = URLEncoder.encode("현재 비밀번호와 다른 비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	// 입력값과 요청값이 다르면 메세지 저장하고 다시 폼으로
	if (!newPasswordCheck.equals(newPassword)){
		String msg = URLEncoder.encode("새로운 비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// DB 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://3.34.33.114:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement updateMemberStmt = null;
	int updateMemberRow = 0;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 결과셋(모델)
	String updateMemberSql = "UPDATE member set member_pw = PASSWORD(?), updatedate = now() where member_id = ? AND member_pw = PASSWORD(?)";
	updateMemberStmt = conn.prepareStatement(updateMemberSql);
	updateMemberStmt.setString(1, newPassword);
	updateMemberStmt.setString(2, loginMemberId);
	updateMemberStmt.setString(3, currentPassword);
	updateMemberRow = updateMemberStmt.executeUpdate();
	System.out.println(updateMemberRow + " <- updateMemberAction updateMemberRow");
	// 수정 결과 메세지 저장
	if (updateMemberRow == 1){
		String msg = URLEncoder.encode("수정이 완료되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
	} else {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
	}
%>