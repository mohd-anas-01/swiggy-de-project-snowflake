CREATE OR REPLACE PROCEDURE SWIGGY.PUBLISH.CREATE_VIEWS()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    -- Create views in the Publish schema for each report
    CREATE OR REPLACE VIEW Swiggy.Publish.user_demographics_report AS
    SELECT * FROM Swiggy.Transform.user_demographics_report;

    CREATE OR REPLACE VIEW Swiggy.Publish.restaurant_performance_report AS
    SELECT * FROM Swiggy.Transform.restaurant_performance_report;

    CREATE OR REPLACE VIEW Swiggy.Publish.order_trends_report AS
    SELECT * FROM Swiggy.Transform.order_trends_report;

    CREATE OR REPLACE VIEW Swiggy.Publish.top_customers_report AS
    SELECT * FROM Swiggy.Transform.top_customers_report;

    RETURN ''Views created successfully in Publish schema'';
END;
';

-- This will orchestrate all the SPs
CREATE OR REPLACE PROCEDURE SWIGGY.PUBLISH.MASTER()
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
    CALL Swiggy.Landing.load_all_tables();
    
    -- Generating Reports
    CALL Swiggy.Transform.generate_all_reports();

    -- Call the stored procedure to create views
    CALL Swiggy.Publish.create_views();

    RETURN ''All reports generated and views created successfully'';
END;
';