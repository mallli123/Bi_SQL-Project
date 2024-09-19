                          
	                        -- PIEOLOGY SALES Analysis--
                             
create  database if not exists SalesAnalysis ; -- TO analyze SALESDATA of a  Pizza Company

CREATE TABLE orders (        -- To create a table orders  --
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

-- To get the total number of orders--
SELECT 
    COUNT(order_id)
FROM
    orders;

-- To get toatl number of pizza sales --

SELECT 
    SUM(quantity) AS Total_pizza_sales
FROM
    order_details;

-- To caluculate total revenue--

SELECT 
    ROUND(SUM(quantity * price), 2) AS revenue
FROM
    order_details
        LEFT JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- To get the most expensive pizza--

SELECT 
    price, pizza_types.name
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- To get top 5 commonly orderded pizza size--

SELECT 
    size, COUNT(quantity)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size;


-- To get most number of  orderes  catagory  in pizza  --
    
SELECT 
    category, SUM(order_details.quantity) AS Total_orders
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;

-- To know Which Hour has most number of sales --

SELECT 
    HOUR(order_time) AS x, COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);
-- Group the orders by date and calculate the average number of pizzas ordered per day--
SELECT 
    ROUND(AVG(sold), 0) AS daily_avg
FROM
    (SELECT 
        order_date AS z, SUM(quantity) AS sold
    FROM
        order_details
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY z
    ORDER BY sold DESC) AS orders_quantity;
    
-- Calculate the percentage contribution of each pizza type to total revenue --

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2)
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;






