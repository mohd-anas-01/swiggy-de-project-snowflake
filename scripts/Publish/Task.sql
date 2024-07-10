create or replace task SWIGGY.PUBLISH.RUN_MASTER
	warehouse=COMPUTE_WH
	schedule='USING CRON */5 * * * * UTC'
	as CALL Swiggy.PUBLISH.MASTER();