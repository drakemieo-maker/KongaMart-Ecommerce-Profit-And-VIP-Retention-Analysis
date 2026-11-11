USE KongAMart_Ecommerce;

SELECT 
	Product_Category, 
    COUNT(Order_ID) AS Delivered_Orders,
    SUM(Gross_Revenue_Naira) AS Total_Gross_Revenue,
    SUM(Discount_Given_Naira) AS Total_Discounts,
    SUM(Gross_Revenue_Naira - Product_Cost_Naira - Discount_Given_Naira) AS True_Net_Profit
FROM Orders_Log
WHERE Order_Status = 'Delivered'
GROUP BY Product_Category
ORDER BY True_Net_Profit DESC;

SELECT 
	Payment_Type, 
	COUNT(Order_ID) AS Total_Orders,
	SUM(CASE WHEN Order_Status = 'Delivered' THEN 1 ELSE 0 END) AS Successful_Deliveries,
	SUM(CASE WHEN Order_Status != 'Delivered' THEN 1 ELSE 0 END) AS Failed_or_Rejected_Orders,
	SUM(CASE WHEN Order_Status != 'Delivered' THEN Gross_Revenue_Naira ELSE 0 END) AS Lost_Revenue_Naira
FROM Orders_Log
GROUP BY Payment_Type
ORDER BY Lost_Revenue_Naira DESC;

SELECT 
    c.Customer_Name,
    c.Acquisition_Channel,
    COUNT(o.Order_ID) AS Total_Delivered_Orders,
    SUM(o.Gross_Revenue_Naira) AS Total_Spent_Naira,
    MAX(o.Order_Date) AS Last_Order_Date,
    CASE 
        WHEN SUM(o.Gross_Revenue_Naira) >= 300000 THEN 'VIP Whale'
        WHEN SUM(o.Gross_Revenue_Naira) >= 100000 THEN 'Regular Buyer'
        ELSE 'Low-Spend Buyer'
    END AS Customer_Tier
FROM Orders_Log o
INNER JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_Name, c.Acquisition_Channel
ORDER BY Total_Spent_Naira DESC;