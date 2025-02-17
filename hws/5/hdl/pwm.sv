/*
  A pulse width modulation module 
*/

module pwm(clk, rst, ena, step, duty, out);

parameter N = 8;

input wire clk, rst;
input wire ena; // Enables the output.
input wire step; // Enables the internal counter. You should only increment when this signal is high (this is how we slow down the PWM to reasonable speeds).
input wire [N-1:0] duty; // The "duty cycle" input.
output logic out;

logic [N-1:0] counter;

// Create combinational (always_comb) and sequential (always_ff @(posedge clk)) 
// logic that drives the out signal.
// out should be off if ena is low.
// out should be fully zero (no pulses) if duty is 0.
// out should have its highest duty cycle if duty is 2^N-1;
// bonus: out should be fully zero at duty = 0, and fully 1 (always on) at duty = 2^N-1;
// You can use behavioural combinational logic, but try to keep your sequential
//   and combinational blocks as separate as possible.
logic [N-1:0] ticks;
initial counter = 0;
initial out = 0;
always_comb ticks = out ? duty : 2**N-1-duty; // set ticks to length of duty when out is high or to the remainder of the duty
always_ff @( posedge step ) begin
  if (rst) begin
    counter <= 0;
    ticks <= duty;
    out <=0;
  end
  else if(ena) begin 
    // When counter is at ticks and not 0 or 2^N-1, reset count and flip out
      if (counter == ticks & duty != 0 & duty != 2**N-1) begin 
        out <= ~out;
        counter <= 0;
      end  
      else begin
        counter <= counter+1;
      end 
  end
end
endmodule
