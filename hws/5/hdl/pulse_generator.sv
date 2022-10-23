/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter;
logic counter_comparator;
always_ff @( posedge clk ) begin
  if (rst) begin
    counter <= 0;
  end
  else if(ena) begin 
      if (counter == ticks) begin 
        out = 1;
        counter <= 0;
      end  
      else begin
        counter <= counter+1;
        out = 0;
      end 
  end
end

endmodule
