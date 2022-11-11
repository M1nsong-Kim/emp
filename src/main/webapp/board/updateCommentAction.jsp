<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>
<%
	// 1
	request.setCharacterEncoding("UTF-8"); //한글
	// 방어 코드
	if(request.getParameter("boardNo") == null || request.getParameter("commentNo") == null ||  request.getParameter("commentPw") == null ||  request.getParameter("commentContent") == null
		|| request.getParameter("commentPw").equals("") || request.getParameter("commentContent").equals("")){
			response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp");
			return;
	}
	System.out.println(Integer.parseInt(request.getParameter("commentNo")) +"<--코멘트번호");	//디버깅
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	String commentContent = request.getParameter("commentContent");
	String createdate = request.getParameter("createdate");
	
	//나중에 분리 생각해서
	Comment c = new Comment();
	c.boardNo = boardNo;
	c.commentNo = commentNo;
	c.commentPw = commentPw;
	c.commentContent = commentContent;
	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩-댓글 수정"); //디버깅
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + " : 댓글 수정 conn"); //디버깅
	String sql = "UPDATE comment SET comment_content = ? WHERE comment_no = ? and comment_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, c.commentContent);
	stmt.setInt(2, c.commentNo);
	stmt.setString(3, c.commentPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){	//맞는 비밀번호를 입력했다면
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+c.boardNo);
		System.out.println("댓글 수정 성공");
	}else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요.", "UTF-8");
		// 게시글 번호와 msg를 넘기며 폼으로 돌아감
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?boardNo="+c.boardNo+"&commentNo="+commentNo+"&msg="+msg);
		System.out.println("댓글 수정 실패");
	}
	
	// 3
%>