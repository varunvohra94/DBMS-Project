# Passenger Preference(Uber or Lyft)			ok			
select d.drivercompany,count(d.drivercompany) from Driver D,ridehistory RH						
where D.DriverID = RH.DriverID group by d.drivercompany;						
						
#Which arer the busiest states?				4		
select d.driverstate,count(bi.driverID) from driver d, bookinginformation bi						
where d.driverid = bi.driverid						
group by (d.driverstate) order by count(bi.driverID) desc;						
						
						
#What are the average rating of drivers per state?				5		
select d.driverstate,avg(R.DRating)						
	from rating R,driver d,bookinginformation bi					
where d.driverid = bi.driverid and bi.bookingid = r.bookingid						
group by d.driverstate order by avg(R.DRating) desc	;					
						
						
#What are the average rating of Passengers per state?				6		
select p.Pstate,avg(R.PRating)						
	from rating R,passenger p,bookinginformation bi					
where p.PassengerID = bi.PassengerID and bi.bookingid = r.bookingid						
group by p.pstate order by avg(R.PRating) desc	;					
						
						
# Top 5drivers and passengers - Use Union				8		
(select p.PassengerID as ID, p.PFirstName,avg(R.PRating) as Rating						
	from rating R,passenger p,bookinginformation bi					
where p.PassengerID = bi.PassengerID and bi.bookingid = r.bookingid						
group by p.PassengerID order by avg(R.PRating) desc limit 5,5)						
union						
(select d.DriverID as ID, d.driverfirstname,avg(R.DRating) as Rating						
	from rating R,driver d,bookinginformation bi					
where d.driverid = bi.driverid and bi.bookingid = r.bookingid						
group by d.driverid order by avg(R.DRating) desc limit 5,5)	;					
# Insert data accordingly						
						
#Average Male and Female Rating				7		
select d.drivergender,d.driverstate,avg(drating)						
from driver d, bookinginformation bi, rating r						
where r.BookingID = bi.BookingID and bi.DriverID = d.DriverID						
group by d.drivergender,d.driverstate order by avg(drating) ;						
						
# No of users using Lyft or Uber Per state				3		
select d.driverstate ,d.drivercompany,count(rh.bookingid)						
from driver d, ridehistory rh						
where d.driverid = rh.DriverID						
group by d.DriverState, d.drivercompany;						
						
# Drivers working for Uber and Lyft				2		
select * from driver where drivercompany = 'Uber' or						
driverid in (select driverid from driver where drivercompany = 'Lyft');						
						
						
						
						
						
						
						
#cost for each ride during RushHour and NonRushHour				9		
select bi.PassengerID,bi.PickUpLoc, bi.droploc, d.DriverState,pi.rate_per_mile * bi.distance as Cost,pi.TimeOfDay						
from bookinginformation bi,pricinginformation pi,zone z,driver d, carinfo ci						
where d.DriverState = z.State and						
d.DriverID = bi.DriverID and						
z.zonenumber = pi.Zone and						
d.DriverID = ci.DriverID and						
pi.typeofcar = ci.cartype and						
pi.TimeOfDay = 'RushHour'						
and (bi.BookingID in (select bookingid from ridehistory))						
group by bi.bookingID,PickUpLoc, bi.droploc						
UNION						
select bi.PassengerID,bi.PickUpLoc, bi.droploc, d.DriverState,pi.rate_per_mile * bi.distance as Cost,pi.TimeOfDay						
from bookinginformation bi,pricinginformation pi,zone z,driver d, carinfo ci						
where d.DriverState = z.State and						
d.DriverID = bi.DriverID and						
z.zonenumber = pi.Zone and						
d.DriverID = ci.DriverID and						
pi.typeofcar = ci.cartype and						
pi.TimeOfDay = 'NonRushHour'						
and (bi.BookingID in (select bookingid from ridehistory))						
group by bi.bookingID,pi.TimeOfDay;						
						
						
						
#Cancelled Rides						
select * from bookinginformation						
where bookinginformation.BookingID not in						
(select BookingID from ridehistory)						
order by Passengerid;						