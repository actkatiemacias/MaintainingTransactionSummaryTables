
/****** Object:  Trigger [dbo].[sales_transasction_insert]    Script Date: 06/11/2013 17:46:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[sales_transasction_insert]
on [dbo].[sales_transaction]
INSTEAD OF INSERT
AS BEGIN

--first insert into our sales_transaction table
INSERT INTO sales_transaction
(sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, sales_product_list_sid,sales_territory_sid, amount, qty)
SELECT sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, sales_product_list_sid,sales_territory_sid, amount, qty
FROM inserted

--then update the sales_transaction_summary table where group by value exists
--given product
UPDATE    sales_transaction_summary
SET              amount = sales_transaction_summary.amount + inserted_summary.amount, qty = sales_transaction_summary.qty + inserted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, SUM(amount) AS amount, SUM(qty) 
                                              AS qty
                       FROM          inserted
                       WHERE sales_product_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid) 
                      AS inserted_summary INNER JOIN
                      sales_transaction_summary ON inserted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      inserted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      inserted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      inserted_summary.sales_product_sid = sales_transaction_summary.sales_product_sid 
--given product list
UPDATE    sales_transaction_summary
SET              amount = sales_transaction_summary.amount + inserted_summary.amount, qty = sales_transaction_summary.qty + inserted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid,  SUM(amount) AS amount, SUM(qty) 
                                              AS qty
                       FROM          inserted
                       WHERE sales_product_list_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid) 
                      AS inserted_summary INNER JOIN
                      sales_transaction_summary ON inserted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      inserted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      inserted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      inserted_summary.sales_product_list_sid = sales_transaction_summary.sales_product_list_sid 



--combination not already in sale_transaction_summary
--given product 
Insert into sales_transaction_summary
([sales_type_sid]
           ,[sales_period_sid]
           ,[sales_account_sid]
           ,[sales_product_sid]
           ,[amount]
           ,[qty])
SELECT     inserted_summary.sales_type_sid, inserted_summary.sales_period_sid, inserted_summary.sales_account_sid, 
	inserted_summary.sales_product_sid, 
	inserted_summary.amount,inserted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid, SUM(amount) as amount, sum(qty) as qty  
                       FROM          inserted
                       where sales_product_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_sid) 
                      AS inserted_summary LEFT OUTER JOIN
                      sales_transaction_summary ON inserted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      inserted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      inserted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      inserted_summary.sales_product_sid = sales_transaction_summary.sales_product_sid 
                     WHERE     (sales_transaction_summary.sales_type_sid IS NULL) AND (sales_transaction_summary.sales_period_sid IS NULL) AND 
                      (sales_transaction_summary.sales_account_sid IS NULL) AND (sales_transaction_summary.sales_product_sid IS NULL) 
--given product  list                     
Insert into sales_transaction_summary
([sales_type_sid]
           ,[sales_period_sid]
           ,[sales_account_sid]
           ,[sales_product_list_sid]
           ,[amount]
           ,[qty])
SELECT     inserted_summary.sales_type_sid, inserted_summary.sales_period_sid, inserted_summary.sales_account_sid, 
	inserted_summary.sales_product_list_sid, 
	inserted_summary.amount,inserted_summary.qty
FROM         (SELECT     sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid, SUM(amount) as amount, sum(qty) as qty  
                       FROM          inserted
                       where sales_product_list_sid is not null
                       GROUP BY sales_type_sid, sales_period_sid, sales_account_sid, sales_product_list_sid) 
                      AS inserted_summary LEFT OUTER JOIN
                      sales_transaction_summary ON inserted_summary.sales_type_sid = sales_transaction_summary.sales_type_sid AND 
                      inserted_summary.sales_period_sid = sales_transaction_summary.sales_period_sid AND 
                      inserted_summary.sales_account_sid = sales_transaction_summary.sales_account_sid AND 
                      inserted_summary.sales_product_list_sid = sales_transaction_summary.sales_product_list_sid 
                     WHERE     (sales_transaction_summary.sales_type_sid IS NULL) AND (sales_transaction_summary.sales_period_sid IS NULL) AND 
                      (sales_transaction_summary.sales_account_sid IS NULL) AND (sales_transaction_summary.sales_product_list_sid IS NULL) 
                      



END