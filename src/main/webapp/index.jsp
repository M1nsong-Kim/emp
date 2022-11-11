<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/empCss.css">
	<style>
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
				<h1 class="text-center">INDEX</h1>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="text-dark text-decoration-none fs-3">부서 관리 / </a>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="text-dark text-decoration-none fs-3">사원 관리 / </a>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="text-dark text-decoration-none fs-3">게시판 관리</a>
			</div>
		</div>
	</div>
</body>
</html>

