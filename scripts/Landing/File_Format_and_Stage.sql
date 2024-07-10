-- Create File Format for CSV
CREATE OR REPLACE FILE FORMAT LANDING.my_csv_format
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1;

-- Create Stage to Load Data
CREATE OR REPLACE STAGE LANDING.my_stage;
