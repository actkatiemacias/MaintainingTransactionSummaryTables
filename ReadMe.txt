Project:  RSS Programming project
Author: Katie Macias
Date: 6/11/2013

Description: 

The following files:

trigger_sales_transaction_delete.sql
trigger_sales_transaction_insert.sql
udf_get_rate.sql
usp_run_sales_results.sql

when run against the database as defined by the entity relationship diagram provided should 
1) maintain the sales_transaction_summary table such that it is always consistent with the data reflected in the sales_transaction table and 
2) populate the sales_result table when ran for a specific period.


Overall Assumptions: 
The database as defined by the entity relationship diagram  already exists

Task #1 Assumptions: 
TRUNCATE statements against the table sales_transaction are not valid, only method for removal of data is the DELETE command
Code to prevent UPDATES against the table sales_transaction already exists (given assumption in the problem definition)

Task #2 Assumptions:
Code to create entries in the sales_result table is accessed via execution of the stored procedure 'run_sales_result'
The run_saleS_result stored prodcedure takes as a parameter the sales_period_sid as defintion for the 'specific Period' defined in the task description

Considerations:

Task #1: Could maintain the sales_transaction_summary table via trigger or stored procedure
	triggers are always executed, stored procedures must be explicitly called - task #1 stated that this code must 'effectively execute every time data in the table "sales_transaction" is Inserted or Delete" so I used triggers

Task #2: Could populate the sales_result table via query or stored procedure
	stored procedures are stored on the database, task #2 stated that this code is run once a month, therefore always want it available so I used stored procedures
	Getting the correct rate was done via a user defined scalar function because of the many logic branches for getting the appropriate rate. Downside is that this function must execute on every record.
