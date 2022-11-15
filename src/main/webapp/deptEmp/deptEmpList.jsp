<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="vo.*" %>
<%
	// 1
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//검색
	request.setCharacterEncoding("UTF-8");
	String searchDept = request.getParameter("searchDept");
	
	// 2
	// db 연결
	// 코드의 유연성을 높이기 위해 변수에 담기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 2-1. 마지막 페이지
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	
	// 검색
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchDept == null){
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);	
	}else {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+searchDept+"%");
		cntStmt.setString(2, "%"+searchDept+"%");
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
	if(searchDept == null){
		sql = "SELECT de.emp_no empNo, e.first_name firstName, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate  FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	}else {
		sql = "SELECT de.emp_no empNo, e.first_name firstName, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate  FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ? LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchDept+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
	}
	
	ResultSet rs = stmt.executeQuery();
		
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()){
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.emp.firstName = rs.getString("firstName");
		de.dept = new Department();
		de.dept.deptNo = rs.getString("deptNo");
		de.dept.deptName = rs.getString("deptName");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		list.add(de);
	}
	
	
	//입력한 순서와 반대되는 순서로 끝내기
	rs.close();
	stmt.close();
	conn.close();
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
		<div class="menu">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

		<h3>부서별 사원 정보</h3>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야 할 때가 있음 / <a>는 무조건 get 방식 -->
		<div class="alignRight">
			<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post">
				<label for="searchDept">
					<input type="text" name="searchDept" id="searchDept" placeholder="부서 검색">
				 </label>
				<button type="submit" class="btn btn-outline-primary">검색</button>
			</form>
		</div>
		
		<table class="table table-hover">
			<tr>
				<th>사원번호</th>
				<th>이름</th>
				<th>부서번호</th>
				<th>부서이름</th>
				<th>계약날짜</th>
				<th>계약종료날짜</th>			
			</tr>
			<%
				for(DeptEmp de : list){
			%>
					<tr>
						<td class="tdSmall"><%=de.emp.empNo%></td>
						<td style="width:25%"><%=de.emp.firstName%></td>
						<td class="tdSmall"><%=de.dept.deptNo%></td>
						<td style="width:25%"><%=de.dept.deptName%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<div class="text-center">
			<%
				if(searchDept == null){
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
					<%
					if(currentPage > 1){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>					
					<%
					}
					%>
					<span><%=currentPage%></span>
					<%
					if(currentPage < lastPage){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
					}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<%
				} else{
			%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&searchDept=<%=searchDept%>">처음</a>
					<%
					if(currentPage > 1){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&searchDept=<%=searchDept%>">이전</a>					
					<%
					}
					%>
					<span><%=currentPage%></span>
					<%
					if(currentPage < lastPage){
					%>
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&searchDept=<%=searchDept%>">다음</a>
					<%
					}
					%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&searchDept=<%=searchDept%>">마지막</a>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>