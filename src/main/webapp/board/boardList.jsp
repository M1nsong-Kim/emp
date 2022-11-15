<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색
	request.setCharacterEncoding("UTF-8");	//한글
	String searchContent = request.getParameter("searchContent");
	// 1) searchContent == null / 2) searchContent == "" or "단어"
	
	// 2. 요청 처리 후 필요하다면 모델데이터 생성
	final int ROW_PER_PAGE = 10;	// 상수(변수명-대문자)로 선언해 수정 방지
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1. 마지막 페이지 구하기 위한 쿼리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchContent == null){	// null -> 전체 데이터 개수
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	} else {	// 내용에 searchContent를 포함하는 게시글 개수 
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+searchContent+"%");
	}
			
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;	// 전체 행 개수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	// 2-2. 불러오기
	String listSql = null;
	PreparedStatement listStmt = null;
	if(searchContent == null){ // null -> 전체 출력
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter FROM board ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		
	}else {	// 내용에 searchContent를 포함하는 게시글만 출력 
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+searchContent+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
	ResultSet listRs = listStmt.executeQuery();	// model source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // model new data
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardWriter = listRs.getString("boardWriter");
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
		<div class="menu">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

		<h3>자유 게시판</h3>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
		<div class="alignRight">
		<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
			<label for="searchContent">
				<input type="text" name="searchContent" id="searchContent" placeholder="내용 검색">
			 </label>
			<button type="submit" class="btn btn-outline-primary">검색</button>
		</form>
		</div>
		
		
		<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->
		<div>
			<table class="table table-hover">
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>작성자</th>
				</tr>
				
				<%
					for(Board b : boardList){
				%>
						<tr>
							<td class="tdSmall"><%=b.boardNo%></td>
							<!-- 제목 클릭 시 상세보기로 이동 -->
							<td class="exclude"><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>&searchContent=<%=searchContent%>"><%=b.boardTitle%></a></td>
							<td class="tdMedium"><%=b.boardWriter%></td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
		
		<!-- 글쓰기 버튼 -->
		<div class="alignRight">
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
		</div>
		
		<!-- 3-2. 페이징 -->
		<div class="text-center forPadding">
			<%
				if(searchContent == null){			
			%>
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
			<% 
				}else{			
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&searchContent=<%=searchContent%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&searchContent=<%=searchContent%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&searchContent=<%=searchContent%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&searchContent=<%=searchContent%>">마지막</a>
			<% 
				}
			%>
		</div>
	</div>
</body>
</html>