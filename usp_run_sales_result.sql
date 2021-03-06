
/****** Object:  StoredProcedure [dbo].[run_sales_result]    Script Date: 06/11/2013 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Katie Macias
-- Create date: 6/11/2012
-- Description: Create the sales_result table
-- =============================================
CREATE PROCEDURE [dbo].[run_sales_result]
(@sales_period_sid int)

AS
BEGIN
	
	SET NOCOUNT ON;
TRUNCATE TABLE sales_result


--product list given
INSERT INTO sales_result
(sales_type_description, sales_period_description, saleS_period_ending_date,sales_account_description,sales_product_description, amount, qty)
SELECT     sales_type.description AS sales_type_description, sales_period.description AS sales_period_description, 
                      sales_period.period_ending_date AS sales_period_ending_date, sales_account.description AS sales_account_description, 
                      sales_product.description AS sales_product_description, 
                      sales_transaction_summary.amount / product_list_product_count.product_count * dbo.get_rate(sales_transaction_summary.sales_type_sid, 
                      sales_transaction_summary.qty / product_list_product_count.product_count) AS amount, 
                      sales_transaction_summary.qty / product_list_product_count.product_count AS qty
FROM         (SELECT     sales_product_list_sid, COUNT(sales_product_sid) AS product_count
                       FROM          sales_product_list_detail
                       GROUP BY sales_product_list_sid) AS product_list_product_count INNER JOIN
                      sales_transaction_summary ON product_list_product_count.sales_product_list_sid = sales_transaction_summary.sales_product_list_sid INNER JOIN
                      sales_product_list_detail AS sales_product_list_detail_1 ON 
                      sales_transaction_summary.sales_product_list_sid = sales_product_list_detail_1.sales_product_list_sid INNER JOIN
                      sales_product ON sales_product_list_detail_1.sales_product_sid = sales_product.sales_product_sid INNER JOIN
                      sales_period ON sales_transaction_summary.sales_period_sid = sales_period.sales_period_sid INNER JOIN
                      sales_account ON sales_transaction_summary.sales_account_sid = sales_account.sales_account_sid INNER JOIN
                      sales_type ON sales_transaction_summary.sales_type_sid = sales_type.sales_type_sid
WHERE sales_transaction_summary.sales_period_sid = @sales_period_sid

--product given
INSERT INTO sales_result
(sales_type_description, sales_period_description, saleS_period_ending_date,sales_account_description,sales_product_description, amount, qty)
SELECT     sales_type.description AS sales_type_description, sales_period.description AS sales_period_description, 
                      sales_period.period_ending_date AS sales_period_ending_date, sales_account.description AS sales_account_description, 
                      sales_product.description AS sales_product_description, 
                      sales_transaction_summary.amount  * dbo.get_rate(sales_transaction_summary.sales_type_sid, 
                      sales_transaction_summary.qty ) AS amount, 
                      sales_transaction_summary.qty AS qty
FROM                  sales_transaction_summary 
				      INNER JOIN
                      sales_product ON sales_transaction_summary.sales_product_sid = sales_product.sales_product_sid INNER JOIN
                      sales_period ON sales_transaction_summary.sales_period_sid = sales_period.sales_period_sid INNER JOIN
                      sales_account ON sales_transaction_summary.sales_account_sid = sales_account.sales_account_sid INNER JOIN
                      sales_type ON sales_transaction_summary.sales_type_sid = sales_type.sales_type_sid
WHERE sales_transaction_summary.sales_period_sid = @sales_period_sid
END
