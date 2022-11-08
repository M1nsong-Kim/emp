<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INSERT DEPT</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		/* 텍스트상자 */
		.insert {
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
		<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
			<table class="table table-hover">
				<tr>
					<th colspan="2" class="text-center">부서 추가</th>
				</tr>
				<!-- 입력칸 -->
				<tr>
					<td class="text">부서 번호</td>
					<td>
						<input type="text" name="deptNo" class="insert">
					</td>
				</tr>
				<tr>
					<td class="text">부서 이름</td>
					<td>
						<input type="text" name="deptName" class="insert">
					</td>
				</tr>
				<!-- 버튼 -->
				<tr class="text-center">
					<td colspan="2">
						<!-- transparent 안 해도 outline 설정해주면 테두리만 있는 버튼 생성 -->
						<button type="submit" class="btn btn-outline-light">추가</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>