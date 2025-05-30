#1. Определение наивысшей текущей зарплаты в каждом отделе (для подсчета текущей зарплаты, используем фильтр WHERE to_date = '9999-01-01'):
#- Цель: Найти наивысшую текущую зарплату в каждом отделе.
#- Таблицы для использования: salaries (содержит информацию о зарплатах сотрудников), dept_emp (содержит информацию о том, к каким отделам относятся сотрудники).
#- Колонки для отображения: Идентификатор сотрудника (emp_no), зарплата (salary), номер отдела (dept_no), наивысшая зарплата в отделе (max_salary_in_dept).
SELECT s.emp_no, s.salary, de.dept_no, MAX(salary) OVER (PARTITION BY de.dept_no ORDER BY de.dept_no) AS max_salary_in_dept
FROM salaries s JOIN dept_emp de ON s.emp_no = de.emp_no
WHERE s.to_date = '9999-01-01' GROUP BY s.emp_no, s.salary, de.dept_no HAVING MAX(s.salary) ;


#2. Сравнение зарплаты каждого сотрудника с средней зарплатой в их отделе:
#- Цель: Сравнить зарплату каждого сотрудника с средней зарплатой в его/ее отделе.
#- Таблицы для использования: salaries, dept_emp.
#- Колонки для отображения: Идентификатор сотрудника (emp_no), зарплата (salary), номер отдела (dept_no), средняя зарплата в отделе (avg_salary_in_dept).
SELECT de.emp_no, s.salary, de.dept_no, AVG(s.salary) OVER (PARTITION BY de.dept_no ORDER BY de.dept_no) avg_salary_in_dept
FROM salaries s 
JOIN dept_emp de ON s.emp_no = de.emp_no
GROUP BY de.emp_no, s.salary, de.dept_no HAVING AVG(s.salary);

#3. Ранжирование сотрудников в отделе по стажу работы:
#- Цель: Ранжировать сотрудников в каждом отделе по длительности их работы в компании.
#- Таблицы для использования: employees (содержит информацию о сотрудниках, включая дату найма), dept_emp.
#- Колонки для отображения: Идентификатор сотрудника (emp_no), дата найма (hire_date), номер отдела (dept_no), 
#ранг опыта (experience_rank). То есть мы хотим разделить на партиции по департаменту и сортировать по hire_date.
SELECT e.emp_no, e.hire_date, de.dept_no, 
RANK() OVER (PARTITION BY de.dept_no ORDER BY e.hire_date) AS experience_rank
FROM employees e 
JOIN dept_emp de ON e.emp_no = de.emp_no;

#4.Нахождение следующей должности каждого сотрудника:
#- Цель: Определить, какая должность будет следующей для каждого сотрудника в ходе их карьеры.
#- Таблицы для использования: titles (содержит информацию о должностях сотрудников).
#- Колонки для отображения: Идентификатор сотрудника (emp_no), текущая должность (title), следующая должность (next_title)
SELECT emp_no, title, LEAD( title, 1, 0) OVER (PARTITION BY emp_no) AS next_title
FROM titles 
ORDER BY emp_no;

#5. Определение начальной и последней зарплаты сотрудника:
#- Цель: Узнать, какая была начальная и какая текущая зарплата у каждого сотрудника.
#- Таблицы для использования: salaries (содержит информацию о зарплатах сотрудников).
#- Колонки для отображения: Идентификатор сотрудника (emp_no), текущая зарплата (salary), начальная зарплата (first_salary), последняя зарплата (last_salary).
SELECT emp_no, salary, 
FIRST_VALUE( salary) OVER (PARTITION BY emp_no ORDER BY emp_no) AS first_salary,
LAST_VALUE (salary) OVER (PARTITION BY emp_no ORDER BY emp_no) AS last_salary
FROM salaries;

#6. - Цель: Вычислить скользящее среднее зарплаты для каждого сотрудника, основываясь на его последних трех зарплатах.
#- Таблицы для использования: salaries: содержит информацию о зарплатах сотрудников, включая emp_no (идентификатор сотрудника), salary (зарплата), 
#и from_date (дата начала действия зарплаты).
#- Колонки для отображения: emp_no (идентификатор сотрудника), from_date (дата начала действия зарплаты),
#salary (зарплата), moving_avg_salary (скользящее среднее зарплаты, рассчитанное на основе последних трех зарплат).
SELECT emp_no, from_date, salary,
AVG(salary) OVER (PARTITION BY emp_no ORDER BY from_date ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING) AS moving_avg_salary
FROM salaries;









