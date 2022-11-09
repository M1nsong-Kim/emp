<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");	 //한글
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	// 방어 코드
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")){
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp");
		return;
	}
	// 나중에 분리 생각해서
	Department d = new Department();
	d.deptNo = deptNo;
	d.deptName = deptName;
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 2-1. dept_name 중복검사
	String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){	//이미 있는 부서이름이라면
		String msg = URLEncoder.encode(deptName + "는 사용할 수 없습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 2-2. update 쿼리 실행
	String sql2 = "UPDATE departments SET dept_name=? WHERE dept_no = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, d.deptName);
	stmt2.setString(2, d.deptNo);
	
	int row = stmt2.executeUpdate();
	if(row == 1){
		System.out.println("수정 성공");
	} else {
		System.out.println("수정 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 결과 출력
%>