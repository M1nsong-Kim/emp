<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	String boardWriter = request.getParameter("boardWriter");
	
	//방어코드
	if(boardTitle == null || boardContent == null || boardPw == null){
		String msg = URLEncoder.encode("항목을 비워둘 수 없습니다.", "UTF-8");
		// 메시지와 함께 입력폼으로 돌려보냄
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = "INSERT INTO board(board_title, board_content, board_pw, board_writer, createdate) VALUES(?, ?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardPw);
	stmt.setString(4, boardWriter);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("게시판 글 등록 성공");
	}else{
		System.out.println("게시판 글 등록 실패");
	}
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>