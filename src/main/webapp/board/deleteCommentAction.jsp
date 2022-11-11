<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	System.out.println(commentNo + "번 댓글 삭제");	//디버깅
	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩-댓글 삭제"); //디버깅
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + " : 댓글 삭제 conn"); //디버깅
	String sql = "DELETE FROM comment WHERE comment_no = ? AND comment_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		System.out.println("댓글 삭제 성공");
	}else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요.", "UTF-8");
		// 게시글 번호와 msg를 넘기며 폼으로 돌아감
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
		System.out.println("댓글 삭제 실패");
	}
	
	// 3
%>