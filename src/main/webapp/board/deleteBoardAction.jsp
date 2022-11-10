<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8");	//한글
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardNo + "<--boardNo 값 - 삭제"); //디버깅
	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩-게시판 삭제"); //디버깅
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + " : 게시판 삭제 conn"); //디버깅
	String sql = "DELETE FROM board WHERE board_no = ? and board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("게시판 글 삭제 성공");
	}else {
		System.out.println("게시판 글 삭제 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	// 3
%>