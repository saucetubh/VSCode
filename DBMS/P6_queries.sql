select ProductLine,count(distinct o.productCode) as OrderedProducts from orderdetails o join products p on p.productCode=o.productCode
group by ProductLine having count(orderNumber)>0 order by count(orderNumber) desc;

