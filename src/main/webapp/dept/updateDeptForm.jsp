<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	String deptNo = request.getParameter("deptNo");

	// 방어코드
	if(deptNo == null || deptNo.equals("")){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}

	// 2. 요청 처리 -> 모델데이터
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?";	// where 절에 as말고 칼럼명 그대로
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery();

	String deptName = null;
	Department d = new Department();
	if(rs.next()){
		d.deptNo = deptNo;
		d.deptName = rs.getString("deptName");
	}
	
	// 3. 결과 출력 -> 모델데이터를 사용자가 원하는 형태로 출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>UPDATE DEPT</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		/* 텍스트상자 */
		.update {
			width:400px;
			background:transparent;
			border-color: white;
			color: white;
		}
		.text {
			color: white;
			text-decoration: none;
		}
		body{
			background: linear-gradient(to right, #ff6e7f, #bfe9ff);
		}
		th, td {
			text-align: center;
		}
	</style>
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
			<table class="table table-hover">
				<tr>
					<th colspan="2">부서 수정</th>
				</tr>
				<tr>
					<td class="text">부서번호</td>
					<td>
						<input type="text" name="deptNo" value=<%=d.deptNo%> readonly="readonly" class="update">
					</td>
				</tr>
				<tr>
					<td class="text">부서이름</td>
					<td>
						<input type="text" name="deptName" value=<%=d.deptName%> class="update">
					</td>
				</tr>
				<tr class="text-center">
					<td colspan="2">
						<button type="submit" class="btn btn-outline-light">수정</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>