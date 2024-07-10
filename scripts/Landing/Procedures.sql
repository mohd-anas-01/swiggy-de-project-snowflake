CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.SP_LOAD_FOOD()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
COPY INTO LANDING.food
FROM (SELECT
        $2::STRING AS f_id,
        $3::STRING AS item,
        $4::STRING AS veg_or_non_veg
FROM @my_stage/food.csv )
FILE_FORMAT = my_csv_format
ON_ERROR = CONTINUE;
';


CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.SP_LOAD_MENU()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
COPY INTO LANDING.menu
FROM (SELECT
        $2::STRING AS menu_id,
        $3::INTEGER AS r_id,
        $4::STRING AS f_id,
        $5::STRING AS cuisine,
        $6::FLOAT AS price
FROM @my_stage/menu.csv )
FILE_FORMAT = my_csv_format
ON_ERROR = CONTINUE;
';


CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.SP_LOAD_ORDERS()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
COPY INTO LANDING.orders
FROM (SELECT
        $2::DATE AS order_date,
        $3::INTEGER AS sales_qty,
        $4::FLOAT AS sales_amount,
        $5::STRING AS currency,
        $6::INTEGER AS user_id,
        $7::INTEGER AS r_id
FROM @my_stage/orders.csv )
FILE_FORMAT = my_csv_format
ON_ERROR = CONTINUE;
';


CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.SP_LOAD_RESTAURANT()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
COPY INTO LANDING.restaurant
FROM (SELECT
        $2::INTEGER AS id,
        $3::STRING AS name,
        $4::STRING AS city,
        $5::STRING AS rating,
        $6::STRING AS rating_count,
        $7::STRING AS cost,
        $8::STRING AS cuisine,
        $9::STRING AS lic_no,
        $10::STRING AS link,
        $11::STRING AS address,
        $12::STRING AS menu
FROM @my_stage/restaurant.csv )
FILE_FORMAT = my_csv_format
ON_ERROR = CONTINUE;
';


CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.SP_LOAD_USERS()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
COPY INTO Swiggy.Landing.users
FROM (
    SELECT
        $2::INTEGER AS user_id,
        $3::STRING AS name,
        $4::STRING AS email,
        $5::STRING AS password,
        $6::INTEGER AS Age,
        $7::STRING AS Gender,
        $8::STRING AS Marital_Status,
        $9::STRING AS Occupation,
        $10::STRING AS Monthly_Income,
        $11::STRING AS Educational_Qualifications,
        $12::INTEGER AS Family_size
    FROM @my_stage/users.csv
)
    FILE_FORMAT = (TYPE = ''CSV'', FIELD_OPTIONALLY_ENCLOSED_BY = ''"'', SKIP_HEADER = 1);
';


-- Run all the SPs created above
CREATE OR REPLACE PROCEDURE SWIGGY.LANDING.LOAD_ALL_TABLES()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
    result STRING;
BEGIN
    -- Call the procedure to load the tables
    CALL LANDING.SP_LOAD_FOOD();
    CALL LANDING.SP_LOAD_MENU();
    CALL LANDING.SP_LOAD_ORDERS();
    CALL LANDING.SP_LOAD_RESTAURANT();
    CALL LANDING.SP_LOAD_USERS();

    -- If all procedures run successfully
    result := ''All tables loaded successfully'';
    
    RETURN result;
END;
';