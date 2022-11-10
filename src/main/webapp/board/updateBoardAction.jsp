<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1
	request.setCharacterEncoding("UTF-8"); //한글
	// 방어 코드
	if(request.getParameter("boardNo") == null || request.getParameter("boardPw") == null ||  request.getParameter("boardTitle") == null ||  request.getParameter("boardContent") == null ||  request.getParameter("boardWriter") == null ||  request.getParameter("createdate") == null
		|| request.getParameter("boardPw").equals("") || request.getParameter("boardTitle").equals("") ||  request.getParameter("boardContent").equals("") || request.getParameter("boardWriter").equals("") || request.getParameter("createdate").equals("") ){
			response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp");
			return;
	}
	//java.lang.NumberFormatException: Cannot parse null string 
	// -> 정수로 바꿀 문자가 없어서 뜨는 예외 -> 방어코드를 위로
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createdate = request.getParameter("createdate");
	//나중에 분리 생각해서
	Board b = new Board();
	b.boardNo = boardNo;
	b.boardPw = boardPw;
	b.boardTitle = boardTitle;
	b.boardContent = boardContent;
	b.boardWriter = boardWriter;
	b.createdate = createdate;
	
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "UPDATE board SET board_title=?, board_content=?, board_writer=? WHERE board_no = ? and board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, b.boardTitle);
	stmt.setString(2, b.boardContent);
	stmt.setString(3, b.boardWriter);
	stmt.setInt(4, b.boardNo);
	stmt.setString(5, b.boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("게시판 글 수정 성공");
	}else {
		System.out.println("게시판 글 수정 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	// 3
%>