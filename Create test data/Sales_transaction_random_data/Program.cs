using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Sales_transaction_random_data
{
    class Program
    {
        static void Main(string[] args)
        {
            //product given
            string filePath = @"C:\Users\Katie\Documents\Projects\SQL Transaction and Summary Tables\test_data.csv";
            string delimiter = ",";

            StringBuilder sb = new StringBuilder();
            Random random = new Random();

            // 100M rows of data
            for (int i = 0; i < 10000000; i++)
            {
                //sales type (1,4), 
                // sales_period, 
                // sales_account, 
                // sales_product, 
                // sales_product_list
                // sales_territory, 
                // amount, 
                // qty
                sb.AppendLine(string.Join(delimiter,
                    random.Next(1, 4),
                    random.Next(1, 4),
                    random.Next(1, 10),
                    random.Next(1, 20),
                    "",
                    random.Next(1, 5),
                    random.Next(0, 100),
                    random.Next(-10, 100)));
            }
            // 50M rows of data
            for (int i = 0; i < 5000000; i++)
            {
                //sales type (1,4), 
                // sales_period, 
                // sales_account, 
                // sales_product, 
                // sales_product_list
                // sales_territory, 
                // amount, 
                // qty
                sb.AppendLine(string.Join(delimiter,
                    random.Next(1, 4),
                    random.Next(1, 4),
                    random.Next(1, 10),
                    "",
                    random.Next(1,3),
                    random.Next(1, 5),
                    random.Next(0, 100),
                    random.Next(-10, 100)));
            }

            File.WriteAllText(filePath, sb.ToString());

        }

    }
}
