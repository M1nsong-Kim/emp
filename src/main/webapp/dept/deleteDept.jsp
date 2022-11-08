<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석(데이터 입력 받기)
	request.setCharacterEncoding("UTF-8");
	String deptNo = request.getParameter("deptNo");
	System.out.println(deptNo + "<--deptNo 값"); //디버깅
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩-delete"); //디버깅
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + "<--conn"); //디버깅
	String sql = "DELETE FROM departments WHERE dept_no = ?";	// as 불필요
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("삭제 성공");
	} else {
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 결과 출력(삭제는 출력 없음)
%>