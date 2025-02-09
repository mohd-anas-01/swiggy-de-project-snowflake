create or replace TABLE SWIGGY.TRANSFORM.ORDER_TRENDS_REPORT (
	ORDER_DATE DATE,
	MONTH NUMBER(2,0),
	YEAR NUMBER(4,0),
	TOTAL_ORDERS NUMBER(18,0),
	TOTAL_QUANTITY NUMBER(38,0),
	TOTAL_SALES_AMOUNT FLOAT
);


create or replace TABLE SWIGGY.TRANSFORM.RESTAURANT_PERFORMANCE_REPORT (
	RESTAURANT_ID NUMBER(38,0),
	RESTAURANT_NAME VARCHAR(200),
	CITY VARCHAR(200),
	RATING VARCHAR(200),
	RATING_COUNT VARCHAR(200),
	COST VARCHAR(200),
	CUISINE VARCHAR(200),
	TOTAL_ORDERS NUMBER(38,0),
	TOTAL_SALES_AMOUNT FLOAT
);


create or replace TABLE SWIGGY.TRANSFORM.TOP_CUSTOMERS_REPORT (
	USER_ID NUMBER(38,0),
	AGE NUMBER(38,0),
	GENDER VARCHAR(200),
	TOTAL_SPENT FLOAT,
	RANK_WITHIN_AGE_GROUP NUMBER(18,0)
);


create or replace TABLE SWIGGY.TRANSFORM.USER_DEMOGRAPHICS_REPORT (
	AGE NUMBER(38,0),
	GENDER VARCHAR(200),
	MARITAL_STATUS VARCHAR(200),
	OCCUPATION VARCHAR(200),
	MONTHLY_INCOME VARCHAR(200),
	USER_COUNT NUMBER(18,0),
	AVG_INCOME NUMBER(23,6)
);