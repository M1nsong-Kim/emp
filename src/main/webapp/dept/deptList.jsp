<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석+a(Controller)
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, list ... ))
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩");	// 디버깅
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + "   : conn");	//디버깅
	// 쿼리: 자바 변수 선언 방식에 맞게 as로 컬럼명 선언
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no desc";	//쿼리
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 쿼리 실행, 사용 / rs : 모델
	ResultSet rs = stmt.executeQuery();	// 모델데이터 ResultSet은 일반적x, 독립적x
	// ResultSet rs라는 모델자료구조를 일반적이고 독립적인 자료구조로 변경
	ArrayList<Department> list = new ArrayList<Department>();

	while(rs.next()){	// ResultSet의 API(사용방법)를 모르면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}

	// 3. 출력(View) -> 모델데이터를 사용자가 원하는 형태로 출력 - 뷰(리포트)

	// 1+2+3 -> MVC 구조
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DEPT LIST</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		.text {
			color: white;
			text-decoration: none;
			hover: none;
		}
		body{
			background: linear-gradient(to right, #ff6e7f, #bfe9ff);
		}
		h1{
			color: white;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1 class="text-center">DEPT LIST</h1>
		<div>
			<!-- 부서 목록 출력(부서번호 내림차순) -->
			<table class="table table-hover">
				<tr>
					<th>부서번호</th>
					<th>부서이름</th>
					<th>추가</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				<%
					for(Department d : list){	// 자바 문법에서 제공하는 foreach문
					
				%>
						<tr>
							<td class="text-white text-decoration-none"><%=d.deptNo%></td>
							<td class="text-white text-decoration-none"><%=d.deptName%></td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="text">추가</a>
							</td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>" class="text">수정</a>
							</td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>" class="text">삭제</a>
							</td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>
</body>
</html>