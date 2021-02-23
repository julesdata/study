<집계연산>

--문제 1-1 
locations 테이블에는 전 세계에 있는 지역 사무소 주소 정보가 나와 있습니다. 각
국가별로 지역사무소가 몇 개나 되는지 찾는 쿼리를 작성해 보세요. 

select country_id, 
    count(*)
from locations
group by country_id
order by 1;

--문제 1-2
employees 테이블에서 년도에 상관 없이 분기별로 몇 명의 사원이 입사했는지 구하는
쿼리를 작성해 보세요.

select to_char(hire_date,'Q'),
        count(*)
from employees
group by to_char(hire_date,'Q')
order by 1;

--문제 1-3
다음 쿼리는 employees 테이블에서 job_id별로 평균 급여를 구한 것인데, 여기서 평균을
직접 계산하는 avg_salary1 이란 가상컬럼을 추가해 보세요. ( 평균 = 총 금액 / 사원수)
SELECT job_id, ROUND(AVG(salary),0) avg_salary
FROM employees
GROUP BY job_id
ORDER BY 1;

--->
SELECT job_id, ROUND(AVG(salary),0) avg_salary, round(sum(salary)/count(*)) avg_salary1
FROM employees
GROUP BY job_id
ORDER BY 1;

--문제 1-4
COVID19 테이블에서 한국(ISO_CODE 값이 KOR)의 월별 코로나 확진자 수를 조회하는
문장을 작성하시오.

select to_char(dates, 'YYYY-MM'), sum(new_cases)
from covid19
where iso_code = 'KOR'
group by to_char(dates,'YYYY-MM')
order by 1;

--문제 1-5
COVID19 테이블에서 한국 데이터에 대해 다음 결과가 나오도록 문장을 작성하시오.
월별 확진사 수, 사망자 수, 사망률
단, 월별 사망률 = 사망자 수 / 확진자 수
   (주의: 분모가 0일 경우는 사망률은 0)

select to_char(dates, 'YYYY-MM') MONTHS, sum(new_cases) 확진자수, sum(new_deaths) 사망자수,
       decode(sum(new_cases),0,0,round(sum(new_deaths)/sum(new_cases)*100,2)) 사망률
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

--문제 1-6
COVID19 테이블에서 2020년 10월에 가장 많은 확진자가 나온 상위 5개 국가는 어떤
나라일까요?

select country, sum(new_cases)
from covid19
where to_char(dates, 'YYYY-MM') = '2020-10'
group by country
order by 2 desc;

--선생님답안
SELECT COUNTRY, NVL(SUM(new_cases),0)   --케이스 '0' 제외
FROM covid19
WHERE 1=1   --AND 앞 부터 주석처리 쉽게 하기위한 팁
AND DATES BETWEEN TO_DATE('20201001','YYYYMMDD')  --날짜추출은 범주(btw then)사용하는 것을 추천. 이유는 날짜에 인덱스를 보통 많이 거는데, 인덱스가 걸린 열을 가공 할 경우 추출이 안될 수 있다. 
AND TO_DATE('20201031','YYYYMMDD')
AND COUNTRY <> 'World'       --전체 총계 제외
GROUP BY COUNTRY
ORDER BY 2 DESC;

--문제 2-1
다음 쿼리를 실행하면 오류가 발생하는데 그 이유는 무엇일까요?
SELECT job_id jobs
FROM employees
WHERE department_id = 60
UNION
SELECT job_id
FROM employees
WHERE department_id = 90
ORDER BY job_id;

첫 SELECT문에서 컬럼명을 지정했기 때문에 ORDER BY 절에는 지정한 컬럼명을 적어야한다.
정답 :
첫 번째 쿼리의 select 절에서 job_id의 alias를 jobs로 주었기 때문에 맨 끝에 있는 order by
절에서 job_id 대신 jobs를 명시해야 합니다.



--문제 2-4
COVID19 테이블에서 2020년 전반기(1월~6월)에는 월별 확진자가 10000명 이상이었는데,
후반기(7월~10월)에는 월별 확진자가 1000명 이하로 떨어진 적이 있는 국가를 구하는
문장을 작성하시오. (힌트: INTERSECT 연산자 사용)

어떻게풀어볼까?
1) 전반기 월별 확진자 10000명이상 국가 구하기
select country, to_char(dates, 'YYYY-MM'), sum(new_cases)
from covid19
where dates > to_date('20191231', 'YYYY-MM-DD') 
        and dates < to_date('20200701', 'YYYY-MM-DD') 
group by country, to_char(dates, 'YYYY-MM')
having sum(new_cases) >= 10000
order by 1,2;

2) 후반기 월별 확진자 1000명 이하 국가 구하기
select country, to_char(dates, 'YYYY-MM'), sum(new_cases)
from covid19
where dates > to_date('20200630', 'YYYY-MM-DD') 
        and dates < to_date('20201101', 'YYYY-MM-DD') 
group by country, to_char(dates, 'YYYY-MM')
having sum(new_cases) <= 1000
order by 1,2;

3) 교집합하여 국가 추리기
--> 1)과 2)를 그대로 intersect하니 안나오네..? 왜지? :3개 열의 각각 모두 같아야 교집합되는데, 월도 확진자수도 다르니 당연히 안나안나옴!
--> 그럼 각각 country만 추출해볼까? 
select country
from covid19
where dates > to_date('20191231', 'YYYY-MM-DD') 
        and dates < to_date('20200701', 'YYYY-MM-DD') 
group by country
having sum(new_cases) >= 10000 --월별 만명 이상이 아닌, 전반기 전체 합 만명 이상이 추출된다..

--> 3개열 추출한 테이블에서 다시 country만 뽑도록 해야겠다! 
select country
from( select country, to_char(dates, 'YYYY-MM'), sum(new_cases)
        from covid19
        where dates > to_date('20191231', 'YYYY-MM-DD') 
        and dates < to_date('20200701', 'YYYY-MM-DD') 
        group by country, to_char(dates, 'YYYY-MM')
        having sum(new_cases) >= 10000
        order by 1,2)
intersect
select country
from( select country, to_char(dates, 'YYYY-MM'), sum(new_cases)
        from covid19
        where dates > to_date('20200630', 'YYYY-MM-DD') 
        and dates < to_date('20201101', 'YYYY-MM-DD') 
        group by country, to_char(dates, 'YYYY-MM')
        having sum(new_cases) <= 1000
        order by 1,2);

---선생님 정답:

SELECT country
FROM covid19
WHERE DATES BETWEEN TO_DATE('20200101','YYYYMMDD') AND TO_DATE('20200630','YYYYMMDD')  
GROUP BY TO_CHAR(dates, 'YYYY-MM'), COUNTRY      ---##Group by 문의 열 갯수가 select절의 열 갯수와 같을 필요 없구나! 
HAVING NVL(SUM(new_cases),0) >= 10000
INTERSECT
SELECT COUNTRY
FROM covid19
WHERE DATES BETWEEN TO_DATE('20200701','YYYYMMDD') AND TO_DATE('20201031','YYYYMMDD')
GROUP BY TO_CHAR(dates, 'YYYY-MM') , COUNTRY
HAVING NVL(SUM(new_cases),0) <= 1000 ;

**나와 다른 점 (더 간략하게 하는 법)
1) Group by 문의 열 갯수가 select절의 열 갯수와 같을 필요 없음. select에 추출하는 열이 포함되어 있기만 하면 됨
2) 날짜 범주는 between ~ and 이용!
3) NVL함수로, 혹시모를 오류방지
