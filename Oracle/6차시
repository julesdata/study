<서브쿼리>

(스칼라_select절, 인라인_from절, 중첩_where절 ,세미조인_where절 서브쿼리 사용 시 ,안티조인_세미조인에서 Not연산자 이용)
질문: 중첩서브쿼리와 세미조인의 명확한 차이가 뭐지?  

--연습문제

6-1-1. 다음 문장은 어떤 정보를 조회하는지 설명해 보세요.

SELECT a.employee_id
,a.first_name || ' ' || a.last_name emp_name
,a.job_id
,a.salary
,( SELECT AVG(b.salary)
FROM employees b
WHERE a.job_id = b.job_id
GROUP BY b.job_id
) avg_salary
FROM employees a; 

부서별 평균 급여 이상의 금액을 지급 받는 사원 조회 (각각의 서브쿼리로 표현 해보자 !) 

--6-1-2. 다음 쿼리를 LATERAL 키워드를 사용해 같은 결과를 조회하도록 변경해 보세요

SELECT b.department_name, loc.street_address, loc.country_name
FROM departments b
,( SELECT l.location_id, l.street_address, c.country_name
    FROM locations l, countries c
    WHERE l.country_id = c.country_id ) loc
WHERE b.location_id = loc.location_id;

-->
/*SELECT l.location_id, l.street_address, c.country_name
    FROM locations l, countries c
    WHERE l.country_id = c.country_id; */

SELECT b.department_name, loc.street_address, loc.country_name
FROM departments b
,lateral( SELECT l.location_id, l.street_address, c.country_name
    FROM locations l, countries c
    WHERE l.country_id = c.country_id 
    and b.location_id = l.location_id) loc;    --lateral절 사용하여 where절 안에서 조인이 가능하므로, 참조하는 테이블 이름은 별칭이 아닌, 원래 테이블로 해줘야함
    
--6-1-3. 다음 문장을 IN 대신 EXISTS 연산자를 사용해 같은 결과를 조회하도록 변경해 보세요.
SELECT employee_id,job_id, salary
FROM employees
WHERE (job_id, salary ) 
    IN ( SELECT job_id, min_salary
        FROM jobs);   

SELECT a.employee_id, a.job_id, a.salary            --exist로 조인할 것이기에 열 이름앞에 테이블 명 지정 필요!
FROM employees a
WHERE EXISTS( SELECT 1
                from jobs b
                where a.job_id = b.job_id
                    and a.salary = b.min_salary);    

/* 6-1-4. 다음은 ANTI 조인 문장입니다. 이 문장은 employees 테이블에 할당되지 않은 부서정보를
조회하려는 문장인데, 실행하면 데이터가 조회되지 않습니다. 해당 부서정보를 조회하도록
이 쿼리를 수정해 보세요. 

SELECT *
FROM departments
WHERE department_id NOT IN
( SELECT a.department_id
FROM employees a
) ;    */

SELECT *
FROM departments 
WHERE department_id NOT IN
( SELECT department_id
FROM employees; --결과 왜 안나오는지 모르겠.
  --where department_id is not null) ; 추가 해야 한다는데 이유는??? 

--교재 antijoin 예시
SELECT a.employee_id,
a.first_name || ' ' || a.last_name
FROM employees a                    --in 구문인데 꼭 'a'를 붙혀야 하는지
WHERE a.employee_id
NOT IN ( SELECT employee_id
FROM job_history );

SELECT employee_id,
first_name || ' ' || last_name
FROM employees                    --결과: 안붙혀도 실행됨.
WHERE employee_id
NOT IN ( SELECT employee_id
FROM job_history );

--5. covid19 테이블을 사용해 월별, 대륙별, 국가별 감염수와 각 국가가 속한 대륙을 기준으로 
감염수 비율을 구하는 쿼리를 작성하시오. (서브쿼리 사용) 

--월별,국가별 확진자 서브쿼리
select to_char(dates,'YYYY-MM') months, continent, country, nvl(sum(new_cases),0) new_cases       
from covid19
where new_cases != 0 and country != 'World'
group by to_char(dates,'YYYY-MM'), continent, country
order by 1,2,4 desc;

--월별,국가별,대륙별 확진자,비율
select a.months, a.continent, a.country, a.new_cases, 
        sum(a.new_cases) over(partition by a.months, a.continent) continent_cases,
        round(a.new_cases/sum(a.new_cases) over(partition by a.months, a.continent) * 100,2) rates
from (select to_char(dates,'YYYY-MM') months, continent, country, nvl(sum(new_cases),0) new_cases       
        from covid19
        where new_cases != 0 and country != 'World'
        group by to_char(dates,'YYYY-MM'), continent, country) a
order by 1,2,4 desc;


--대륙별확진자 서브쿼리
select to_char(dates,'YYYY-MM') months, continent, nvl(sum(new_cases),0) continent_cases       
from covid19
where new_cases > 0 and continent is not null
group by to_char(dates,'YYYY-MM'), continent
order by 1,2,3 desc;

--대륙별 확진자 서브쿼리 까지 이용한 방법

select a.months, a.continent, a.country, a.new_cases, b.continent_cases
        ,round(a.new_cases/b.continent_cases * 100,2) rates  
from (select to_char(dates,'YYYY-MM') months, continent, country, nvl(sum(new_cases),0) new_cases       
        from covid19
        where new_cases != 0 and country != 'World'
        group by to_char(dates,'YYYY-MM'), continent, country) a,
     (select to_char(dates,'YYYY-MM') months, continent, nvl(sum(new_cases),0) continent_cases       
        from covid19
        where new_cases > 0 and continent is not null
        group by to_char(dates,'YYYY-MM'), continent) b
  where a.months=b.months
    and a.continent=b.continent
order by 1,2,4 desc;

--중복조건을 한꺼번에 밑으로 내려서 좀더 간단히 만들면?
select a.months, a.continent, a.country, a.new_cases, b.continent_cases
        ,round(a.new_cases/b.continent_cases * 100,2) rates
from (select to_char(dates,'YYYY-MM') months, continent, country, nvl(sum(new_cases),0) new_cases       
        from covid19
        group by to_char(dates,'YYYY-MM'), continent, country) a,
     (select to_char(dates,'YYYY-MM') months, continent, nvl(sum(new_cases),0) continent_cases       
        from covid19
        group by to_char(dates,'YYYY-MM'), continent) b
  where a.months=b.months
    and a.continent=b.continent
    and new_cases > 0
order by 1,2,4 desc;

--6. covid19 테이블을 사용해 2020년 한국의 월별 검사수, 확진자수, 확진율을 구하는 쿼리를
작성하시오.


