`timescale 1ns / 100ps

module SONAR( input CLK, ECHO, RESET,
              output logic TRIG,
              output logic [31:0] DISTANCE);        


reg [31:0] dist_counter=0;
reg [31:0] counter=0;
reg [31:0] echo_time;
reg waitn;

always @ (posedge CLK)
begin
   	
	if (RESET)
		begin
			counter<=0;
			dist_counter<=0;
		end
	else 
	    begin
		if(counter==0 && ECHO ==0)
			TRIG = 1;
		else if (counter <= 10000 && ECHO!=1)         //10usec to initialize sensor
				begin
					TRIG<=0;
					waitn<=1;
				end
		else if (counter==38000000 && ECHO!=1)        //off duration of 38ms for the trigger pulse
		     begin
			 counter<=0;
			 TRIG<=1;
			 end
	 counter=counter+1;		 	

	
	 if (ECHO==1)                   // sensing 3.3v at echo pin so echo pin is high
				begin
					dist_counter <= counter+1;
					waitn <= 0;
					echo_time<=dist_counter;
					counter <=0;
					DISTANCE = echo_time*34000000/2; 
				end
	else if(ECHO!=1 && waitn==1)  //assigning the count of duration of echo to echo_time
		         begin	
		         counter= counter+1;
		         waitn=1;
		         dist_counter <=counter;
		         echo_time<=dist_counter;
		         end
	else if(counter==1000000000 && ECHO!=1)   //refreshing the sensor after 1 seconds
	     begin
	      counter=0;
	      dist_counter=0;
	      TRIG=0;
	     end 	         
	         
	     // speed of sound in air/2	         	
	end
end

endmodule
