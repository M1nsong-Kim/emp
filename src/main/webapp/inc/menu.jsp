<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- patrial jsp 페이지 사용할 코드 -->
	<a href="<%=request.getContextPath()%>/index.jsp">[홈으로]</a>
	<a href="<%=request.getContextPath()%>/dept/deptList.jsp">[부서관리]</a>
	<a href="<%=request.getContextPath()%>/dept/empList.jsp">[사원관리]</a>
	<a href="<%=request.getContextPath()%>/dept/empList.jsp">[연봉관리]</a>
<head>
<style>
	a {
		/*color: white;*/
		text-decoration: none;
		hover: none;
		text-align: center;
	}
</style>
</head>