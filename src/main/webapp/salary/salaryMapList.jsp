<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>	<!-- HashMap<키, 값>, ArrayList<요소> : 컬렉션 -->
<%
	// 1) 요청 분석
	// 페이징 currentPage
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//검색
	request.setCharacterEncoding("UTF-8");
	String searchName = request.getParameter("searchName");
	
	// 2) 요청 처리
	// db 연결 -> 모델 생성
	String driver = "org.mariadb.jdbc.Driver";	//코드의 유연성을 높이기 위해 변수에 담기
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser ="root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 2-1. 페이징 
	// rowPerPage, beginRow
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchName == null){
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	}else {
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+searchName+"%");
		cntStmt.setString(2, "%"+searchName+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt / rowPerPage);
	
	// 2-2.
	String sql = null;
	PreparedStatement stmt = null;
	if(searchName == null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);		
	}else {
		// WHERE절에 CONCAT 함수 한 번에 사용 가능? O
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchName+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);	
	}
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	
	rs.close();
	stmt.close();
	conn.close();
	
	// 3) 


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SALARY LIST</title>
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<h1 class="text-center">연봉 목록</h1>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야 할 때가 있음 / <a>는 무조건 get 방식 -->
		<form action="<%=request.getContextPath()%>/salary/salaryMapList.jsp" method="post">
			<label for="searchName">
				<input type="text" name="searchName" id="searchName" placeholder="사원 성/이름 검색">
			 </label>
			<button type="submit" class="btn btn-outline-primary">검색</button>
		</form>
		
		<table class="table">
			<tr>
				<th>사원번호</th>
				<th>사원이름</th>
				<th>연봉</th>
				<th>계약일자</th>
				<th>계약종료일자</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("name")%></td>
						<td><%=m.get("salary")%></td>
						<td><%=m.get("fromDate")%></td>
						<td><%=m.get("toDate")%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<div class="text-center">
			<%
				if(searchName == null){			
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<% 
				}else{			
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1&searchName=<%=searchName%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&searchName=<%=searchName%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&searchName=<%=searchName%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>&searchName=<%=searchName%>">마지막</a>
			<% 
				}
			%>
		</div>
	</div>
</body>
</html>