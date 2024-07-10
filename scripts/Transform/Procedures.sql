CREATE OR REPLACE PROCEDURE SWIGGY.TRANSFORM.GENERATE_ORDER_TRENDS_REPORT()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    CREATE OR REPLACE TABLE Swiggy.Transform.order_trends_report AS
    SELECT
        DATE(order_date) AS order_date,
        EXTRACT(MONTH FROM order_date) AS month,
        EXTRACT(YEAR FROM order_date) AS year,
        COUNT(order_date) AS total_orders,
        SUM(sales_qty) AS total_quantity,
        SUM(sales_amount) AS total_sales_amount
    FROM Swiggy.Landing.orders
    GROUP BY DATE(order_date), EXTRACT(MONTH FROM order_date), EXTRACT(YEAR FROM order_date)
    ORDER BY order_date;

    RETURN ''Order trends report generated successfully'';
END;
';


CREATE OR REPLACE PROCEDURE SWIGGY.TRANSFORM.GENERATE_RESTAURANT_PERFORMANCE_REPORT()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    CREATE OR REPLACE TABLE Swiggy.Transform.restaurant_performance_report AS
    SELECT
        r.id AS restaurant_id,
        r.name AS restaurant_name,
        r.city,
        r.rating,
        r.rating_count,
        r.cost,
        r.cuisine,
        COALESCE(SUM(o.sales_qty), 0) AS total_orders,
        COALESCE(SUM(o.sales_amount), 0) AS total_sales_amount
    FROM Swiggy.Landing.restaurant r
    LEFT JOIN Swiggy.Landing.orders o ON r.id = o.r_id
    GROUP BY r.id, r.name, r.city, r.rating, r.rating_count, r.cost, r.cuisine;

    RETURN ''Restaurant performance report generated successfully'';
END;
';


CREATE OR REPLACE PROCEDURE SWIGGY.TRANSFORM.GENERATE_TOP_CUSTOMERS_REPORT()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    CREATE OR REPLACE TABLE Swiggy.Transform.top_customers_report AS
    SELECT
        u.user_id,
        Age,
        Gender,
        SUM(sales_amount) AS total_spent,
        RANK() OVER (PARTITION BY Age ORDER BY SUM(sales_amount) DESC) AS rank_within_age_group
    FROM Swiggy.Landing.orders o
    JOIN Swiggy.Landing.users u ON o.user_id = u.user_id
    GROUP BY u.user_id, Age, Gender
    ORDER BY rank_within_age_group;

    RETURN ''Top customers report generated successfully'';
END;
';


CREATE OR REPLACE PROCEDURE SWIGGY.TRANSFORM.GENERATE_USER_DEMOGRAPHICS_REPORT()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    CREATE OR REPLACE TABLE Swiggy.Transform.user_demographics_report AS
    SELECT
        Age,
        Gender,
        Marital_Status,
        Occupation,
        Monthly_Income,
        COUNT(user_id) AS user_count,
        AVG(CASE WHEN Monthly_Income = ''No Income'' THEN 0
                 WHEN Monthly_Income = ''Below Rs.10000'' THEN 5000
                 WHEN Monthly_Income = ''10001 to 25000'' THEN 17500
                 WHEN Monthly_Income = ''25001 TO 50000'' THEN 37500
                 ELSE 60000
            END) AS avg_income
    FROM Swiggy.Landing.users
    GROUP BY Age, Gender, Marital_Status, Occupation, Monthly_Income
    ORDER BY Age;;

    RETURN ''User demographics report generated successfully'';
END;
';


-- Call this SP to create all reports
CREATE OR REPLACE PROCEDURE SWIGGY.TRANSFORM.GENERATE_ALL_REPORTS()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
    result STRING;
BEGIN
    -- Generate each report
    CALL SWIGGY.TRANSFORM.generate_user_demographics_report();
    CALL SWIGGY.TRANSFORM.generate_restaurant_performance_report();
    CALL SWIGGY.TRANSFORM.generate_order_trends_report();
    CALL SWIGGY.TRANSFORM.generate_top_customers_report();

    result := ''All reports generated successfully'';
    
    RETURN result;
END;
';