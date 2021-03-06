
/****** Object:  Trigger [dbo].[sales_transaction_delete]    Script Date: 06/11/2013 17:47:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Katie Macias
-- Create date: 6/9/2013
-- Description:	Executes delete statement and syncronized the summary table if necessary
-- =============================================
CREATE TRIGGER [dbo].[sales_transaction_delete]
   ON  [dbo].[sales_transaction]
AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


--then update the sales_transaction_summary table where group by value exists
--given product
UPDATE    sales_transaction_summary
SET              amount = sales_transaction_summary.amount- deleted_summary.amount, qty = sales_transaction_summary.qty  - deleted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, SUM(amount) AS amount, SUM(qty) 
                                              AS qty
                       FROM          deleted
                       WHERE sales_product_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid) 
                      AS deleted_summary INNER JOIN
                      sales_transaction_summary ON deleted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      deleted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      deleted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      deleted_summary.sales_product_sid = sales_transaction_summary.sales_product_sid 
--given product list
UPDATE    sales_transaction_summary
SET              amount = sales_transaction_summary.amount - deleted_summary.amount, qty = sales_transaction_summary.qty - deleted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid,  SUM(amount) AS amount, SUM(qty) 
                                              AS qty
                       FROM          deleted
                       WHERE sales_product_list_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid) 
                      AS deleted_summary INNER JOIN
                      sales_transaction_summary ON deleted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      deleted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      deleted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      deleted_summary.sales_product_list_sid = sales_transaction_summary.sales_product_list_sid 


--given product
Delete from sales_transaction_summary
FROM         sales_transaction_summary LEFT OUTER JOIN
                          (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, SUM(amount) AS amount, SUM(qty) AS qty
                            FROM          sales_transaction 
                            GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid) AS transaction_summary ON 
                      sales_transaction_summary.sales_type_sid = transaction_summary.sales_type_sid AND 
                      sales_transaction_summary.sales_period_sid = transaction_summary.sales_period_sid AND 
                      sales_transaction_summary.sales_account_sid = transaction_summary.sales_account_sid AND 
                      sales_transaction_summary.sales_product_sid = transaction_summary.sales_product_sid
WHERE sales_transaction_summary.sales_product_list_sid is null 
AND transaction_summary.sales_type_sid is null
AND transaction_summary.sales_period_sid is null
AND transaction_summary.sales_account_sid is null                      
AND transaction_summary.sales_product_sid is null


--given product list
Delete from sales_transaction_summary
FROM         sales_transaction_summary LEFT OUTER JOIN
                          (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid, SUM(amount) AS amount, SUM(qty) AS qty
                            FROM          sales_transaction 
                            GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid) AS transaction_summary ON 
                      sales_transaction_summary.sales_type_sid = transaction_summary.sales_type_sid AND 
                      sales_transaction_summary.sales_period_sid = transaction_summary.sales_period_sid AND 
                      sales_transaction_summary.sales_account_sid = transaction_summary.sales_account_sid AND 
                      sales_transaction_summary.sales_product_list_sid = transaction_summary.sales_product_list_sid
WHERE sales_transaction_summary.sales_product_sid is null 
AND transaction_summary.sales_type_sid is null
AND transaction_summary.sales_period_sid is null
AND transaction_summary.sales_account_sid is null                      
AND transaction_summary.sales_product_list_sid is null

END
