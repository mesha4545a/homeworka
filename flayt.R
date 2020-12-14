library(tidyverse)
library(nycflights13)
fl<-flights
View(fl)
#______________________________Filter_________________________________________

View(filter(fl,month == 1, day ==1))
#can put the object name or the data name no difrence at this point 
jan1 <-filter(flights,month == 1, day ==1)
View(jan1)

#something intersting 
#showsb in concel and creat  an object 
(novOrDec <- filter(fl, month == 11 | month == 12))

(noDelay <- filter(fl,dep_delay== 0 & arr_delay == 0))

# can use logical operater in fillter good to know :)

(not_late <- filter(fl, arr_delay ==0))
# you should have idea what you whant to achive usin the filter in here we 
#were comparing the flight that where on shedual the other we whanted to know
#how many arrave in time 
#there is 347 where on schedual but 5409 flight arravied on time
#reason?
#filter is similar to "WHERE" in sql

#____________________________Arrange_________________________________________

a <-arrange(fl, year,month,day)
View(arrange(fl, year,month,day))
# so it arrange according to year then month then day 
#that good but what happen if I arrange just according to month
b <- arrange(fl, month)
View(arrange(fl, month))
# besically the same I wonder whay
#ok what if I arrange just according to day
c <- arrange(fl, day)
View(arrange(fl, day))
# no real differnce mybe the reason is the way the rows or records are put 
#difference maybe shown using different colume
View(arrange(fl, dep_time, sched_dep_time))
# ok there  is defintly difference it arrange according to the frist then if 
#it equal according to the second 
View(arrange(fl,desc(dep_time), sched_dep_time))
#desc() arrange in descnded order it arrange in Descending Order 
#and what happen her is it arrange dep_time in Descending Order
#and arrange sched_dep_time in Aescending Order
#arrange similar to "Order BY"  in sql

#___________________________Select_____________________________________________

select(fl, dep_delay)
select(fl, dep_delay, day)
#shows what I select similar to "select" in sql 

f <- fl[starts_with("M",vars = flights$dest),]
View(f)
# so it like "=M%" in sql mybe

select(fl, dep_delay, everything())

# so it just make dep_delay apper in frist row and everything apper after 

#__________________________Mutatee_____________________________________________

flights_sml <- select(fl,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
# what happen here is reduce the number of columes using select function
#select year,month, day and every column end with delay ,distance and air_time


flights_sml_odd <- mutate(flights_sml,
                      gain = dep_delay - arr_delay,
                      speed = distance / air_time *60,
                      hours = air_time / 60,
                      gain_per_hour = gain / hours)
View(flights_sml_odd)

# ok so we can use select to make table from cloumes I choose then using mutate 
#can add columes that do some calaculations also I can name it 

transmute(fl,
          distance,
          air_time,
          gain = dep_delay - arr_delay,
          speed = distance / air_time *60,
          hours = air_time / 60,
          gain_per_hour = gain / hour)

# so in the frist we used select to cut unwanted columes in the transmute 
#function that uncessary it jest shows what we put in it 
#for some reason  "year:day,ends_with("delay")," didn't work in transmute??
# I think it functions worke only with select function

#____________________________summarise_________________________________________


summarise(fl, delay = mean(dep_delay, na.rm = T))

#it print summary it this priticular example it print the mean for dep_delay 
#"na.rm =t" remove the NA null

by_dest <- group_by(fl, dest)
by_dest
# we did the group_by put did not apply it in class Mr. Robson said that it
#apper when we apply summary function 
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T)
)
delay

#ok so it apper in delay and even though I did not put dest in summary function
#it apper the reason is I did group by dest in "by_dest" and i select it as the 
#data I whant to worke on in delay ....what if i did the same but on fl data??
delay2 <- summarise(fl,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T)
)
delay2
# so worke but without the group by cuse I used the orgine data si it smarise
#everything 

ggplot(data=delay, mapping = aes(x = dist, y = delay))+
  geom_point(aes(size = count),alpha = 1/3)+
  geom_smooth(se= F)

delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data=delay, mapping = aes(x = dist, y = delay))+
  geom_point(aes(size = count),alpha = 1/3)+
  geom_smooth(se= F)

#________________________________________pip_________________________________

delay <- fl %>%
 group_by(dest)%>%
  # the same as by_dest <- group_by(fl, dest)
 summarise(count = n(),
           dist = mean(distance, na.rm = T),
           delay = mean(arr_delay, na.rm = T)
           )%>% 
  # the same as delay <- summarise(.....
           filter( count > 20, dest != "HNL")
# the same as delay <- filter(delay, count > 20, dest != "HNL")
##easier way to the same result

#____________________________________missing Value_____________________________

not_cancelled <- fl %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year,month,day)%>%
  summarize(mean = mean(dep_delay))

delayes <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = T),
    count = n()
  )
delayes

# for  spead use the pip function
#use filter to remove Na value in this case canceled flight
# thean group by what we whant then use summarize to calculate what we whant

ggplot(data = delayes, mapping = aes(x = count, y = delay))+
  geom_point(alpha = 1/10)
# alpha is for transparency

delayes %>% 
  filter(count > 25) %>%
  ggplot( mapping = aes(x = count, y = delay))+
  geom_point(alpha = 1/10)

# ok good we can use the filter function to remove noise and the pip function 
#with ggplot 


