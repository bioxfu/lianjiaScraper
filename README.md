### lianjiaScraper

Install package by running the following command:
```
devtools::install_github("bioxfu/lianjiaScraper")
```
Then search the Lianjia site by running the following command:
```
price <- searchLianjia("sh", page_num = 20)
```
To see the details of function:
```
?searchLianjia
```
The average house price and the location of each community found on Lianjia web page will be scraped into a R data frame.