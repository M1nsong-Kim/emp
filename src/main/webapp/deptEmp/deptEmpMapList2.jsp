<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색
	request.setCharacterEncoding("UTF-8");
	String select = request.getParameter("select");
	String search = request.getParameter("search");
	
	// 2
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println(conn + " ----------- deptEmpMapList conn");
	
	// 2-1. 페이징
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	
	// 검색 여부에 따라 if문 나누기
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(search == null){
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);	
	}else if(select.contains("empNo")){	//사원번호 선택
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE de.emp_no LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+search+"%");
	}else if(select.contains("firstName")){	//사원이름 선택
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+search+"%");
	}else if(select.contains("deptNo")){	//부서번호 선택
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE de.dept_no LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+search+"%");
	}else if(select.contains("deptName")){	//부서이름 선택
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+search+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt/rowPerPage);
	
	// 2-2. 정보
	String sql = null;
	PreparedStatement stmt = null;
	if(search == null){
		sql = "SELECT de.emp_no empNo, e.first_name firstName, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate  FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	}else {
		sql = "SELECT de.emp_no empNo, e.first_name firstName, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate  FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ? LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
	}
	
	ResultSet rs = stmt.executeQuery();
	
	// DeptEmp.class가 없다면 deptEmpMapList.jsp
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> hm = new HashMap<String, Object>();
		hm.put("empNo", rs.getInt("empNo"));
		hm.put("firstName", rs.getString("firstName"));
		hm.put("deptNo", rs.getString("deptNo"));
		hm.put("deptName", rs.getString("deptName"));
		hm.put("fromDate", rs.getString("fromDate"));
		hm.put("toDate", rs.getString("toDate"));
		list.add(hm);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DEPT EMP LIST</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/empCss.css">
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<h1 class="text-center">부서별 사원 정보</h1>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
		<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post">
			<label for="search">
				<select name="select">
					<option value="empNo">사원번호</option>
					<option value="firstName">사원이름</option>
					<option value="deptNo">부서번호</option>
					<option value="deptName">부서이름</option>
				</select>
				<input type="text" name="search" id="search" placeholder="선택 후 검색하세요">
			 </label>
			<button type="submit" class="btn btn-outline-primary">검색</button>
		</form>
		
		<table class="table">
			<tr>
				<td>사원번호</td>
				<td>이름</td>
				<td>부서번호</td>
				<td>부서이름</td>
				<td>계약날짜</td>
				<td>계약종료날짜</td>			
			</tr>
			<%
				for(HashMap<String, Object> hm : list){
			%>
					<tr>
						<td><%=hm.get("empNo")%></td>
						<td><%=hm.get("firstName")%></td>
						<td><%=hm.get("deptNo")%></td>
						<td><%=hm.get("deptName")%></td>
						<td><%=hm.get("fromDate")%></td>
						<td><%=hm.get("toDate")%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<div class="text-center">
			<%
				if(search == null){
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=1">처음</a>
					<%
					if(currentPage > 1){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=currentPage-1%>">이전</a>					
					<%
					}
					%>
					<span><%=currentPage%></span>
					<%
					if(currentPage < lastPage){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
					}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=lastPage%>">마지막</a>
			<%
				} else{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=1&search=<%=search%>">처음</a>
					<%
					if(currentPage > 1){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>">이전</a>					
					<%
					}
					%>
					<span><%=currentPage%></span>
					<%
					if(currentPage < lastPage){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>">다음</a>
					<%
					}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList2.jsp?currentPage=<%=lastPage%>&search=<%=search%>">마지막</a>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>