// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;
typedef enum logic {COUNTING_UP, COUNTING_DOWN} state_t;
state_t state;
logic [N-1:0] high;
always_comb high = ~0;
always_ff @( posedge clk ) begin
    if (rst) begin
        state <= COUNTING_DOWN;
        out <= 0;
    end else if (ena) begin
        out <= out + (state == COUNTING_UP ? 1 : ~0);
    end
end

always_ff @(posedge (out == 0 | out == high)) begin
    state <= state == COUNTING_UP ? COUNTING_DOWN : COUNTING_UP;
end

endmodule