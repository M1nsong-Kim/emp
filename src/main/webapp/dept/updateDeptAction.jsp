<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");	 //한글
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 쿼리
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 자리에 입력한 값 넣기
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정 성공");
	} else {
		System.out.println("수정 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 결과 출력
%>