<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- patrial jsp 페이지 사용할 코드 -->
	<div class="container">
		<a href="<%=request.getContextPath()%>/index.jsp">[홈으로]</a>
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp">[부서관리]</a>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp">[사원관리]</a>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp">[게시판관리]</a>
		<a href="<%=request.getContextPath()%>/dept/empList.jsp">[연봉관리]</a>
	</div>
<head>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/empCss.css">
</head>