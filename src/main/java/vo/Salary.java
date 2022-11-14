package vo;

public class Salary {
	// public int empNo;	// 장점: 객체 없어도 사용 가능 단점: inner 조인 결과물 받을 수 없다
	public Employee emp;	// 장점: 조인 결과물 받을 수 있다 단점: 계속 employee 객체 만들어야 함
	public int salary;
	public String fromDate;
	public String toDate;
	
	public static void main(String[] args) {
		Salary s = new Salary();
		// s.empNo = 1;
		s.emp = new Employee();
		s.emp.empNo = 1;
		s.salary = 5000;
		s.fromDate = "2021-01-01";
		s.toDate = "2021-12-31";
		
	}
}
