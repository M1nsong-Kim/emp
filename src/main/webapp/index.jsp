<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		body{
			background: linear-gradient(to right, #ff6e7f, #bfe9ff);
		}
		
		h1{
			color:white;
		}
		/* container 전체 가운데 정렬*/
		.container {
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100vh;
		}
	</style>
</head>
<body>
	
	<div class="container">
		<div class="row">
			<div>
				<h1>INDEX</h1>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="text-white text-decoration-none fs-3">부서 관리</a>
			</div>
		</div>
	</div>
</body>
</html>

