
/****** Object:  UserDefinedFunction [dbo].[get_rate]    Script Date: 06/11/2013 17:45:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Katie Macias
-- Create date: 6/11/2013
-- Description:	Determines the appropriate rate to use for a given quantity and sales_type_id
-- =============================================
CREATE FUNCTION [dbo].[get_rate]
(
	@sales_type_sid int,
	@qty numeric(25,9)
)
RETURNS numeric(25,9)
AS
BEGIN
Declare @final_rate numeric(25,9) 
Declare @sales_type_rate numeric(25,9)
Declare @sales_range_rate numeric(25,9)

--condition 1: rate_type_sid is null
set @sales_type_rate = (SELECT      rate
FROM         sales_type
WHERE     (sales_type_sid = @sales_type_sid))

set @sales_range_rate = (SELECT     sales_rate_range.rate
FROM         sales_rate_range INNER JOIN
                      sales_rate_type ON sales_rate_range.rate_type_sid = sales_rate_type.rate_type_sid INNER JOIN
                      sales_type ON sales_rate_type.rate_type_sid = sales_type.rate_type_sid
WHERE @sales_type_sid = sales_type_sid and @qty between begin_range_value and end_range_value)
						

set @final_rate = coalesce(@sales_range_rate, @sales_type_rate)

return @final_rate
END
