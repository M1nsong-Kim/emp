<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	//페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//검색
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String search = request.getParameter("search");
	// 1. search == null, 2) search == "" or "단어"
	
	// 2
	int rowPerPage = 10;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// lastPage 처리
	String countSql = null;
	PreparedStatement countStmt = null;
	if(search == null){	//전체 출력
		countSql = "SELECT COUNT(*) FROM employees";
		countStmt = conn.prepareStatement(countSql);		
	}else {
		countSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+search+"%");
		countStmt.setString(2, "%"+search+"%");
	}
	
	
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count/rowPerPage != 0){
		lastPage++;		//나머지가 있다면 몫+1
	}
	
	// 한페이지당 출력할 emp목록
	String empSql = null;
	PreparedStatement empStmt = null;
	
	if(search == null){
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no asc LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage - 1));
		empStmt.setInt(2, rowPerPage);		
	}else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no asc LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+search+"%");
		empStmt.setString(2, "%"+search+"%");
		empStmt.setInt(3, rowPerPage * (currentPage - 1));
		empStmt.setInt(4, rowPerPage);	
	}
	
	
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EMP LIST</title>
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>사원목록</h1>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
		<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
			<label for="search">
				<input type="text" name="search" id="search" placeholder="성/이름 검색">
			 </label>
			<button type="submit" class="btn btn-outline-primary">검색</button>
		</form>
		
		<table class="table">
			<tr>
				<th style="width:50px">사원번호</th>
				<th style="width:500px">퍼스트네임</th>
				<th style="width:150px">라스트네임</th>
			</tr>
			<%
				for(Employee e : empList){
			%>
					<tr>
						<td><%=e.empNo%></td>
						<td><%=e.firstName%></td>
						<td><%=e.lastName%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		
		<!-- 페이징 -->
		<div class="text-center">
			<%
				if(search == null){
					%>
					
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
					<%
						//첫 번째에선 이전 안 눌리도록
						if(currentPage > 10){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-10%>">이전</a>					
					<%
						}
						
						int pageList = (currentPage / 10 * 10)+1;	//페이지 번호: 1의자리 제거 후 +1
						for(int i = 0; i < 10 ; i++){
							if(currentPage % 10 == 0){	//10의 배수라면
								pageList = ((currentPage/10)-1)*10+1;	// 10의자리를 하나 낮춘 후 +1
							}
							
							//현재 페이지만 굵게
							if(currentPage == pageList+i){
								%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>">
										<span class="currentPage"><%=pageList+i%></span>
									</a>	
								<%
								continue;	// break를 포함한 밑의 코드로 가지 않도록 다음 i로 넘어감
							}
							
							// 문제점 1. 지금 데이터 기준 30000에서 라스트페이지의 나머지+1에 해당하는 4가 안뜸 
							// -> 사이에 껴서 해결했는데 코드가 지저분해보임			
							if( (currentPage/10) >= (lastPage/10)  && i == lastPage%10){	//끝자리와 10으로 나눈 몫이 같고 마지막 페이지의 1의 자리 수와 같다면
							
								if(currentPage % 10 == 0){
									%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>"><%=pageList+i%></a>	
									<%
									continue;	// break를 포함한 밑의 코드로 가지 않도록 다음 i로 넘어감
								}
								break;
							}
					%>
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>"><%=pageList+i%></a>		
					<%
						}
						
						//마지막에선 다음 안 눌리도록
						if((currentPage/10) < (lastPage/10) || ((currentPage/10) == (lastPage/10) && currentPage % 10 == 0)){
							// 문제점 2. 지금 데이터 기준 30000에서 페이지 '다음' 안 뜨고 29994~29999에서 '다음' 누르면 현재 페이지가 30004~30009(데이터에 없는 쪽)이 뜸 
							// -> if 조건 추가하고 마지막 페이지로 보내서 해결했지만 지저분
							if(currentPage + 10 > lastPage){
								%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">다음</a>
								<%
							}else{	//현재 페이지 +10을 해도 마지막 페이지 범위 안쪽이라면
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+10%>">다음</a>
					<%		}
						}
					%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
					<%
					
				}else {	// 검색 입력값이 있을 때
			%>
			
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&search=<%=search%>">처음</a>
					<%
						//첫 번째에선 이전 안 눌리도록
						if(currentPage > 10){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-10%>&search=<%=search%>">이전</a>					
					<%
						}
						
						int pageList = (currentPage / 10 * 10)+1;	//페이지 번호: 1의자리 제거 후 +1
						for(int i = 0; i < 10 ; i++){
							if(currentPage % 10 == 0){	//10의 배수라면
								pageList = ((currentPage/10)-1)*10+1;	// 10의자리를 하나 낮춘 후 +1
							}
							
							//현재 페이지만 굵게
							if(currentPage == pageList+i){
								%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>&search=<%=search%>">
										<span class="currentPage"><%=pageList+i%></span>
									</a>	
								<%
								continue;	// break를 포함한 밑의 코드로 가지 않도록 다음 i로 넘어감
							}
							
							// 문제점 1. 지금 데이터 기준 30000에서 라스트페이지의 나머지+1에 해당하는 4가 안뜸 
							// -> 사이에 껴서 해결했는데 코드가 지저분해보임			
							if( (currentPage/10) >= (lastPage/10)  && i == lastPage%10){	//끝자리와 10으로 나눈 몫이 같고 마지막 페이지의 1의 자리 수와 같다면
							
								if(currentPage % 10 == 0){
									%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>&search=<%=search%>"><%=pageList+i%></a>	
									<%
									continue;	// break를 포함한 밑의 코드로 가지 않도록 다음 i로 넘어감
								}
								break;
							}
					%>
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=pageList+i%>&search=<%=search%>"><%=pageList+i%></a>		
					<%
						}
						
						//마지막에선 다음 안 눌리도록
						if((currentPage/10) < (lastPage/10) || ((currentPage/10) == (lastPage/10) && currentPage % 10 == 0)){
							// 문제점 2. 지금 데이터 기준 30000에서 페이지 '다음' 안 뜨고 29994~29999에서 '다음' 누르면 현재 페이지가 30004~30009(데이터에 없는 쪽)이 뜸 
							// -> if 조건 추가하고 마지막 페이지로 보내서 해결했지만 지저분
							if(currentPage + 10 > lastPage){
								%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&search=<%=search%>">다음</a>
								<%
							}else{	//현재 페이지 +10을 해도 마지막 페이지 범위 안쪽이라면
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+10%>&search=<%=search%>">다음</a>
					<%		}
						}
					%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&search=<%=search%>">마지막</a>
					<%
				}
			%>
			
		</div>
	</div>
</body>
</html>