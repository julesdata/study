#2-1-4 country_test 테이블생성
>
create table country_test(
COUNTRY_ID number not null comment '국가번호',
COUNTRY_NAME varchar2(100) not null comment '국가명'
);

alter table country_test
add constraint country_test_pk primary key(country_id);

--oracle에서 comment생성 방법
comment on column [테이블명].[컬럼명] is '설명'
comment on column country_test.country_id is '국가번호'
comment on column country_test.country_name is '국가명';

#2-1-5. country_test 테이블에 REGION_ID 란 컬럼을 추가하는 문장을 작성하세요.
(REGION_ID : 숫자형, NULL 허용 컬럼)
>
alter table country_test
add REGION_ID number; 

#2-1-6.  country_test 테이블의 REGION_ID 는 NULL 허용 컬럼입니다. 이를 NOT NULL
컬럼으로 변경하는 문장을 작성하세요. 
>
alter table country_test
modify REFION_ID not null;

#2-1-7. country_test 테이블을 삭제하는(제거하는) 문장을 작성해 보세요. 
>
drop table country_test;

##자꾸 틀리는 Point!##
add 와 modify뒤에 'column'이라고 지정할 필요 없이 바로 column명을 써주면 된다!


#2-2-4.Locations 테이블은 부서의 주소 관련 데이터가 담겨있습니다. 
     이 테이블의 컬럼과 데이터 형 (타입), 각 컬럼의 NULL허용 여부를 찾아 정리해 보세요.
>
desc locations;

>
이름             널?       유형           
-------------- -------- ------------ 
LOCATION_ID    NOT NULL NUMBER(4)    
STREET_ADDRESS          VARCHAR2(40) 
POSTAL_CODE             VARCHAR2(12) 
CITY           NOT NULL VARCHAR2(30) 
STATE_PROVINCE          VARCHAR2(25) 
COUNTRY_ID              CHAR(2)      

#2-2-5. LOCATIONS 테이블에서 LOCATION_ID 값이 2000보다 크거나 같고 3000 보다 작은
건을 조회하는 문장을 작성해 보세요.
>
select *
from locations
where location_id >= 2000
  and location_id < 3000;
  
--where location_id between 2000 and 3000; 을 사용하게되면 3000을 포함한다. (이상~이하)

#2-2-6. EMPLOYEES 테이블에서 FIRST_NAME이 'David'이고 급여가 6000이상인 사람이 속한
부서가 위치한 도시를 찾는 문장을 작성해 보세요. (힌트: 3개의 문장이 필요함)
>
select * 
from employees
where first_name = 'David'
    and salary >= 6000;

select *
from departments
where department_id = 80;

select *
from locations
where location_id = 2500;

#2-3-1. Employees 테이블의 manager_id 컬럼에는 해당 사원의 상관의 사번이 저장되어
있습니다. 따라서 가장 높은 직급인 사장은 이 컬럼에 값이 들어 있지 않습니다. 사장을
조회하는 쿼리를 작성해 보세요. 

#2-3-2. employees 테이블에는 인센티브 값이 있는 commission_pct 컬럼이 있습니다. 그런데
commission_pct를 모든 사원이 받는 것은 아니어서 이 컬럼 값이 null인 건이 존재합니다.
Null인 건은 salary만, null이 아닌 건은 salary + (salary * commission_pct) 로 처리하는
Case 표현식을 작성해 보세요. 

#2-3-3. 다음 문장을 실행하면 조회되는 로우는 몇 건일까요?
SELECT employee_id, first_name, last_name
FROM employees
WHERE ROWNUM < 1;

#2-3-4. LOCATIONS 테이블에서 도시 이름이 S로 시작하는 건을 도시이름으로 내림차순
정렬해 조회하는 문장을 작성하시오.

#2-3-5. LOCATIONS 테이블에서 미국에 있는 사무실(country_id 값이 US)에 우편물을 보내려고
주소를 작성하고자 합니다. 다음과 같은 형태로 결과가 조회되도록 문장을 작성하시오.
(우편번호 – 거리명 – 도시명 – 주명 – 국가코드 )

#2-3-6. 5번 문제에서 미국이 아닌 영국(country_id값이 UK)에 있는 사무실 주소를 조회한
결과인데, 첫 번째 건의 우편번호가 없습니다. 우편번호가 없는 건을 제외하고 조회하는 문장을
작성하시오. 

#2-3-7. 6번 문제에서 우편번호가 없는 건을 제외하는 대신 우편번호가 없는 건은 우편번호를
'99999'로 나오도록 조회하는 문장을 작성하시오.

