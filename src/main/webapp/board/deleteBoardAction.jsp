<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
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
	if(row == 1){	//맞는 비밀번호를 입력했다면
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	}else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요.", "UTF-8");
		// 게시글 번호와 msg를 넘기며 폼으로 돌아감
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
		System.out.println("게시판 글 삭제 실패");
	}
	
	// 3
%>