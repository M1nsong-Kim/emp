<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%

	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 방어코드 - deptNo, deptName으로 받은 뒤에 해도 가능	
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")){
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요.", "UTF-8");	//get방식 주소창 한글 인코딩
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청 처리
	// 이미 존재하는 key(dept_no)값에 이미 있는 값이 들어오면 예외 발생 -> 동일한 dept_no값이 입력됐을 때의 예외 방지
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 2-1-1. dept_no 중복검사
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?";	// OR로 또는 조건 주기
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){	// true -> 부서번호만 중복 / 부서이름만 중복 / 둘 다 중복 모두 해당	(or은 앞이 true라면 뒤는 확인하지 않는다)
		// 둘 중 하나만 중복된 경우 어떤 값이 중복인지는 따로 명시x(rs.next()는 어떤 값이 중복되든 true 반환해서 구분 불가)
		// ↑노출 가능성 고려
		// get방식 주소창 한글 인코딩
		String msg = URLEncoder.encode(deptNo + " 혹은 " + deptName + "가 중복되었습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 2-2. 입력
	String sql2 = "INSERT INTO departments(dept_no, dept_name) VALUES(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	int row = stmt2.executeUpdate();
	if(row == 1){
		System.out.println("입력 성공");
	} else {
		System.out.println("입력 실패");
	}
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>