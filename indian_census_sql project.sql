use sql_project1;

select * from Data1;
select * from Data2;

 --- number of rows in data tables ---

select count(*) from  Data1;
select count(*) from  Data2;

 --- dataset from jharkhand and bihar ---

 select * from Data1 
 where state in ('Jharkhand' , 'Bihar')
 order by state ;

 --- states with higher population ---

select top 3 state, sum(population) st_population from Data2
 group by state
 order by sum(population) desc;
 
 --- population of maharashtra ---

 select sum(population) as mah_population from data2
 where state  = 'Maharashtra'

 --- avg growth ---

 select state, avg(growth)*100 as per_avg_growth  from data1
 group  by state
 order by  per_avg_growth desc;
  
  -- top 3 states with highest avg growth --

 select top 3 state, round(avg(growth)*100,1) as per_avg_growth  from data1
 group  by state
 order by  per_avg_growth desc ;

 --- avg sex ratio ---

 select state, round(avg(Sex_Ratio),0) as avg_sex_ratio  from data1
 group  by state
 order by  avg_sex_ratio desc;

  --- states with least avg sex ratio ---

 select top 3 state, round(avg(Sex_Ratio),0) as avg_sex_ratio  from data1
 group  by state
 order by  avg_sex_ratio ;

 --- literacy rate ---

 select state, round(avg(Literacy),1) as avg_literacy  from data1
 group  by state
 order by  avg_literacy desc;

 --- highest 3 and lowest 3 states in literacy rate in same table ---

 create view top3 as
 select top 3 state, round(avg(Literacy),1) as avg_literacy  
 from data1
 group  by state
 order by  avg_literacy desc;

 create view bottom3 as
 select top 3 state, round(avg(Literacy),1) as avg_literacy  
 from data1
 group  by state
 order by  avg_literacy ;
 

 select  * from top3
 union 
 select  * from bottom3
 order by avg_literacy desc


 --- states population per area km ---

 select state , round(sum(population)/sum(area_km2),2) as pop_per_area from Data2
 group by state
 order by pop_per_area desc;

 --- literacy and sex_ratio relation ---

select  state, avg(sex_ratio) as sex_rat ,avg(literacy) as lit_rat from Data1
group by state
order by avg(literacy) desc

 ---  district in maharashtra starting from a ----

 select * from data1
 where district like 'A%' and state = 'Maharashtra'

 --- getting population and growth from 2 tables ---

select d1.state ,round( avg(d2.population),1) as avg_pop ,round( avg(d1.growth),1) as avg_gro from data1 d1
inner join Data2 d2
on d1.District = d2.District
group by d1.state
order by avg_pop desc

 --- total literate people in state ---

select d1.state ,round(round( avg(d2.population) * avg(d1.Literacy) , 0)/ 100 ,0) as lit_people ,
round(avg(population),0)  -  round(round( avg(d2.population) * avg(d1.Literacy) , 0)/ 100 ,0) as illeterate_people 
from data1 d1
inner join Data2 d2
on d1.District = d2.District
group by d1.state
order by lit_people desc

--- population of last census ---

 prev + (prev * growth) = pop
 prev(1 + growth) = pop
 prev = pop/(1+growth)


 select  d1.State ,sum(d2.population) as curr_pop, round(sum(d2.population)/(1+sum(d1.growth)),0) as prev_pop
 from Data1 d1
 inner join Data2 d2
 on d1.District = d2.District
 group by d1.state
 order by prev_pop desc

 --- top 3 dis with highest literacy rate from each state --- 
 
 select a.* from 
 ( select district,state,literacy,RANK() over (partition by state order by literacy desc)as rnk from Data1 ) as a
 where rnk in (1,2,3)
 order by State desc
