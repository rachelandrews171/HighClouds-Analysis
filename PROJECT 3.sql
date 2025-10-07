create database HighClouds;
use  HighClouds;

show tables;

#KPIS
select count(*) from maindata;
select count(`ï»¿%Airline ID`) from airlines;
select avg(Transported_Passengers/Available_Seats*100) as LOADFACTOR from maindata;
SELECT COUNT(Transported_Passengers) from maindata;
select count(distinct(`Origin City`)) from maindata;


describe maindata;

# modifytable

alter table `aircraft types` rename to `aircraft_types`;
alter table `aircraft groups` rename to `aircraft_groups`;
alter table `carrier groups` rename to `carrier_groups`;
alter table `carrier operating region` rename to `carrier_operating_region`;
alter table `destination markets` rename to `destination_markets`;
alter table `distance groups` rename to `distance_groups`;
alter table `flight types` rename to `flight_types`;
alter table `origin markets` rename to `origin_markets`;

#modifycolumn

alter table maindata rename column `Distance_Group_ID` to `%Distance_Group_ID`;
alter table maindata rename column `# Available Seats` to `Available_Seats`;
alter table maindata rename column `From - To City` to `From_To_city`;
alter table maindata rename column `Carrier Name` to `Carrier_Name`;
alter table maindata rename column `# Transported Passengers` to `Transported_Passengers`;
alter table distance_groups rename column `ï»¿%Distance Group ID` to `Distance_Group_ID`;
alter table distance_groups rename column `Distance Interval` to `distance_interval`;
alter table maindata rename column `%Airline ID` to `airline_ID`;
alter table maindata rename column `Month (#)` to `Month`;

create view dat_field as
select concat(Year,"-",Month,"-",Day) as date_field ,Transported_Passengers,Available_Seats,From_To_city,Carrier_Name,`%Distance_Group_ID`
from maindata;

SELECT * FROM dat_field;

#QUESTION 1
create view que1 as select date_field ,year(date_field ) as Year_No,month(date_field )as Month_Number,
monthname(date_field ) as Month_Name,day(date_field ) as Day_No,dayname(date_field ) as Day_name,
concat("Q",quarter(date_field )) as Quarter_No,
weekofyear(date_field ) as Week_Of_Year,concat(year(date_field ),'-',monthname(date_field )) as YearMonth,
case
when quarter(date_field )=1 then "FQ4"
when quarter(date_field )=2 then "FQ1"
when quarter(date_field )=3 then "FQ2"
when quarter(date_field )=4 then "FQ3"
end as Finalncial_Quarter,
case
when month(date_field )=4 then "FM1"
when month(date_field )=5 then "FM2"
when month(date_field )=6 then "FM3"
when month(date_field )=7 then "FM4"
when month(date_field )=8 then "FM5"
when month(date_field )=9 then "FM6"
when month(date_field )=10 then "FM7"
when month(date_field )=11 then "FM8"
when month(date_field )=12 then "FM9"
when month(date_field )=1 then "FM10"
when month(date_field )=2 then "FM11"
when month(date_field )=3 then "FM12"
end as Financial_Month,
case
when dayname(date_field ) in ('Saturday','Sunday') then 'Weekend'
else 'weekday'
end  as Weekday_Weekend,
From_to_City, Transported_Passengers, Available_Seats, Carrier_Name
from dat_field ;

select * from que1;

#QUESTION2
select Year_No,concat(round(sum(Transported_Passengers)/sum(Available_Seats) * 100, 2),'%') as Load_factor
from que1
group by Year_No
order by Load_factor desc;

select Month_Name,concat(round(sum(Transported_Passengers)/sum(Available_Seats) * 100, 2),'%') as Load_factor
from que1
group by Month_Name
order by Load_factor desc;


select Quarter_No as Quarter_no,concat(round(sum(Transported_Passengers)/sum(Available_Seats) * 100, 2),'%') as Load_factor
from que1
group by Quarter_No
order by Load_factor desc;

#QUESTION3
select Carrier_Name,
concat(round(sum(Transported_Passengers)/sum(Available_Seats) * 100, 2),'%') as Load_factor
from maindata
group by Carrier_Name
order by Load_factor desc;


#QUESTION4
select Carrier_Name,count(Transported_Passengers) as passengers
from maindata
group by Carrier_Name
order by passengers desc
limit 10;

#QUESTION 5
select From_to_City,COUNT(`airline_ID`) as Num_flights
from maindata 
group by From_to_City
order by Num_flights desc
limit 10;


#QUESTION 6
select Weekday_Weekend,
concat(round(sum(Transported_Passengers)/sum(Available_Seats) * 100, 2),'%') as Load_factor
from que1
group by Weekday_Weekend
order by Load_factor desc;


#QUESTION 7
select `distance_interval`,count(Distance_Group_ID) as Num_of_flights
from distance_groups 
join maindata
on distance_groups.Distance_Group_ID=maindata.`%Distance_Group_ID`
group by `distance_interval`
order by Num_of_flights desc
limit 10;


