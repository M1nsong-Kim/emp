<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 방어코드
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}

	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "INSERT INTO departments(dept_no, dept_name) VALUES(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("입력 성공");
	} else {
		System.out.println("입력 실패");
	}
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>