<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	int currentPage = 3;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// lastPage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
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
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no asc LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
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
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>사원목록</h1>
		<div>현재 페이지: <%=currentPage%></div>
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
		</div>
	</div>
</body>
</html>