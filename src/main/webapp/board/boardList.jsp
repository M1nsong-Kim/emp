<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청 처리 후 필요하다면 모델데이터 생성
	final int ROW_PER_PAGE = 10;	// 상수(변수명-대문자)로 선언해 수정 방지
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 2-1. 마지막 페이지 구하기 위한 쿼리
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;	// 전체 행 개수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 2-2. 전체 테이블 불러오기
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery();	// model source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // model new data
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
	//마지막 페이지
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BOARD LIST</title>
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
		<h1 class="text-center">자유 게시판</h1>
		
		<div style="float:right">
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
		</div>
		
		<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->
		<div>
			<table class="table">
				<tr>
					<th>제목</th>
					<th>내용</th>
				</tr>
				
				<%
					for(Board b : boardList){
				%>
						<tr>
							<td><%=b.boardNo%></td>
							<!-- 제목 클릭 시 상세보기로 이동 -->
							<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a></td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
		<!-- 3-2. 페이징 -->
		<div class="text-center">
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
			<%
				if(currentPage > 1){
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%
				}
			%>
			<span><%=currentPage%></span>
			<%
				if(currentPage < lastPage){
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
		</div>
	</div>
</body>
</html>