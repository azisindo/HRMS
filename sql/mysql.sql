use hr;

select * from employees;

select employee_id,last_name from employees;

desc employees;

select distinct job_id  from employees;

select * from employees  where job_id='AD_VP';

select * from employees where  EMPLOYEE_ID between 100 and 104;

select * from employees where  first_name like '%ha%';

select * from employees; where employee_id=101 and JOB_ID='AD_VP';

SELECT * FROM employees	WHERE EMPLOYEE_ID='109' and job_id='fi_account';

select * from employees order by job_id,first_name asc;


SELECT COUNT(DISTINCT job_id) FROM employees;



