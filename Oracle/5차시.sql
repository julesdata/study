1. Jobs 테이블에는 min_salary와 max_salary란 컬럼이 있는데, 이는 해당 job_id에 대한
최소와 최대급여 금액을 담고 있습니다. Jobs 테이블과 employees 테이블을 조인하고
사원의 급여가 최소와 최대급여 금액을 벗어난 사원이 있는지 조회하는 쿼리를 작성해
보세요.

1)
select a.employee_id, a.first_name||' '||a.last_name, a.salary, b. min_salary, b.max_salary
from employees a, jobs b
where a.job_id = b.job_id
        and (a.salary < b.min_salary or a.salary > b.max_salary)
        --#  a.salary not between b.min_salary and b.max_salary
order by 1;


2) Ansi문
select a.employee_id, a.first_name||' '||a.last_name, a.salary, b. min_salary, b.max_salary
from employees a
    join jobs b
    on a.job_id = b.job_id
where a.salary not between b.min_salary and b.max_salary
order by 1;

2. 아래 외부조인 문장을 실행하면 내부조인을 한 것과 결과가 같습니다. 왜 이런 결과가
나왔는지 설명해 보세요.
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, b.*
FROM employees a,
job_history b
WHERE a.employee_id(+) = b.employee_id
ORDER BY 1;

정답 :
a쪽 테이블 조인조건에 (+)가 붙어 있으므로 b, 즉 job_history 테이블쪽 데이터 중 조인조건에 부합하지
않는 데이터가 조회되어야 합니다.
그런데 job_history 테이블에 있는 employee_id 값은 모두 employees 테이블에 존재하므로 내부조인을 한
것과 같은 결과가 조회되는 것입니다.

--집합연산자 'select ~ from ~ minus select~ from ~'로 확인해볼 수 있다. 

3. 실습시간 마지막에 배웠던 셀프조인의 경우 사번이 100번인 Steven King은 조회되지
않습니다. 그 이유는 뭘까요?

정답 :
사번이 100번인 Steven King의 경우 manager_id 값이 null 이라서 조인조건에서 누락되어
조회되지 않습니다.

4. 실습시간 마지막에 배웠던 셀프조인에서 누락된 사번이 100번인 Steven King 까지
조회되도록 쿼리를 작성해 보세요.

정답 :
SELECT a.employee_id
,a.first_name || ' ' || a.last_name emp_name
,a.manager_id
,b.first_name || ' ' || b.last_name manager_name
FROM employees a
LEFT JOIN employees b
ON a.manager_id = b.employee_di
ORDER BY1;


5. Quiz 2-2-6번 문제인 EMPLOYEES 테이블에서 FIRST_NAME이 'David'이고 급여가
6000이상인 사람이 속한 부서가 위치한 도시를 찾는 쿼리를 3문장이 아닌 1문장으로 작성해
보세요.

정답 :
select a.employee_id, a.first_name, a.last_name, a.salary, b.department_name, c.city
from employees a, departments b, locations c
where 1=1
    and a.department_id = b.department_id
    and b.location_id = c.location_id
    and a.first_name = 'David'
    and a.salary >= 6000;


6. ORDERS, CUSTOMERS, STORES, STAFFS 테이블을 조인해 2018년 1월 주문 내역에
대해 다음 결과처럼 조회하는 쿼리를 작성해 보세요. 

SELECT a.order_id , a.order_date
,b.first_name || ' ' || b.last_name customer_name
,c.store_name
,d.first_name || ' ' || d.last_name staff_name
FROM orders a,
customers b,
stores c,
staffs d
WHERE a.order_date BETWEEN TO_DATE('2018-01-01','YYYY-MM-DD')
AND TO_DATE('2018-01-31','YYYY-MM-DD')
AND a.customer_id = b.customer_id
AND a.store_id = c.store_id
AND a.staff_id = d.staff_id
ORDER BY 2;
Copyright © 2019, All rights reserved. 8

7. ORDERS, ORDER_ITEMS 테이블을 조인해 2018년 월별 주문금액 합계를 조회하는
쿼리를 ANSI 조인으로 작성해 보세요. (주문금액 = order_items 의 quantity * list_price)

SELECT TO_CHAR(a.order_date, 'YYYY-MM') months
,SUM(b.quantity * b.list_price) order_amt
FROM ORDERS A
INNER JOIN ORDER_ITEMS B
ON A.ORDER_ID = B.ORDER_ID
WHERE a.order_date BETWEEN TO_DATE('2018-01-01','YYYY-MM-DD')
AND TO_DATE('2018-12-31','YYYY-MM-DD')
GROUP BY TO_CHAR(a.order_date, 'YYYY-MM')
ORDER BY 1;

8. ORDERS, ORDER_ITEMS, PROUCTS, BRANDS 테이블을 조인해 2018년 분기별, 브랜드별 주문금액
합계를 조회하는데, 주문금액이 10000 이상인 데이터를 조회하는 쿼리를 ANSI 조인으로 작성해 보세요.
(주문금액 = order_items 의 quantity * list_price)

select to_char(a.order_date,'YYYY-Q') quater,
        d.band_name,
        sum(b.quantity * b.list_price) oredr_amt
from orders a
inner join order_items b
    on a.order_id = b.order_id
inner join products c
    on b.product_id = c.product_id
inner join brands d
    on c.brand_id = d.brand_id
where a.order_date between to_date('20180101','YYYYMMDD')
            and to_date('20181231','YYYYMMDD')
group by to_char(a.order_date,'YYYY-Q'),d.brand_name
having sum(b.quantity * b.list_price)>=10000
order by 1, 3 desc;

9. 년도별 매장별 주문금액 합계를 조회하는 쿼리를 ANSI 조인으로 작성해 보세요. 
(주문금액 =order_items 의 quantity * list_price)

select to_char(a.order_date,'YYYY') YEAR,
    c.store_name,
    sum(b.quantity * b.list_price) order_amt
from orders a
inner join order_items b
    on a.order_id = b.order_id
inner join stores c
    on a.store_id = c.store_id
group by to_char(a.order_date,'YYYY'), c.store_name
order by 1;


10. 분석함수를 사용해 다음과 같이 누적합계를 구하는 쿼리를 작성해 보세요.
(힌트: SUM 함수 사용)
정답 :

select b.department_id, b.department_name, a.first_name || ' ' || a.last_name emp_name,
    a.hire_date, a.salary,
    sum(a.salary) over(
        partition by b.department_id
        order by a.hire_date) 누적합계  --order by에 입사일자 외에 a.salary를 추가해야함!! 입사일 같을 경우 전체 합계가 출력됨.
from employees a, departments b
where b.department_id = a.department_id
order by 2,4; --마찬가지로 샐러리 추가. 안하면 기존 셋팅 순서대로 표기됨
