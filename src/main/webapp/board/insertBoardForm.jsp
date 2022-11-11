<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INSERT BOARD</title>
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
		<div>
			<h1>글쓰기</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
			<table class="table">
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="boardTitle" class="box">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea rows="25" name="boardContent" class="box"></textarea>
					</td>
				</tr>
				<tr>
					<td>글쓴이</td>
					<td>
						<input type="text" name="boardWriter" class="box">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="boardPw" class="box">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit" class="btn btn-outline-primary">등록</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>