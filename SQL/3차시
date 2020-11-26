__연습문제 3-1-2

방법 1)

select substr('Is this the real life? Is this just fantasy?',-8)
from dual;

방법 2)
select substr('Is this the real life? Is this just fantasy?',
                instr('Is this the real life? Is this just fantasy?','fant'))
from dual;


__연습문제 3-1-3
select sysdate,
    round(sysdate,'mm') from dual;
    
__연습문제 3-1-4
select months_between(sysdate,hire_date)
    from employees
where employee_id<=110;

__연습문제 3-1-5
select
    replace(phone_number,'.','-')
from employees;

__연습문제 3-1-6

select substr(street_address,(instr(street_address,' ')+1))
from locations
where location_id <=2400;

select ltrim(street_address,'0,1,2,3,4,5,6,7,8,9,-') street_address2
from locations where location_id <= 2400;

__연습문제 3-2-1
select to_char(last_day(to_date('2019-08-20','YYYY-MM-DD')),'DAY')
from dual;

__연습문제 3-2-2
select  employee_id, first_name, last_name, salary, commission_pct, 
        nvl(salary+(salary*commission_pct),salary) as real_salary
from employees;

__연습문제 3-2-3
select  employee_id, first_name, last_name, salary, commission_pct,
        decode(salary*commission_pct,NULL,salary,salary*commission_pct,salary*commission_pct+salary) as real_salary
from employees;

select  employee_id, first_name, last_name, salary, commission_pct,
        decode(commission_pct,NULL,salary,salary*commission_pct+salary) as real_salary
from employees;

__연습문제 3-2-4
방법1)
select 365*to_number(to_char(to_date('2020-10-30','YYYY-MM-DD'),'YYYY')-1)+to_number(to_char(to_date('2020-10-30','YYYY-MM-DD'),'DDD'))
from dual;

방법2)
select to_date('2020-10-31', 'YYYY-MM-DD') - to_date('0001-01-01', 'YYYY-MM-DD')
from dual;
