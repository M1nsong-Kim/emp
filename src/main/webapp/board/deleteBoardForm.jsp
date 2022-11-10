<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*" %>
<%
	// 1
	// 방어코드
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT board_no boardNo, board_pw boardPw FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board b = null;
	if(rs.next()){
		b = new Board();
		b.boardNo = boardNo;
		b.boardPw = rs.getString("boardPw");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DELETE BOARD</title>
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<div>
			<h1 class="text-center">글 삭제하기</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
			<table class="table">
				<tr>
					<td>번호</td>
					<td>
						<input type="text" name="boardNo" value=<%=b.boardNo%> readonly="readonly" class="box">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<!-- 비밀번호는 넘어오면 안 되므로 value값 주지 않음 -->
						<input type="password" name="boardPw" class="box">
					</td>
				</tr>
				<tr class="text-center">
					<td colspan="2">
						<button type="submit" class="btn btn-outline-light">삭제</button>
					</td>
				</tr>
			</table>
		</form>	
	</div>
</body>
</html>