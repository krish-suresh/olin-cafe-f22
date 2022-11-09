
# for i in range(32):
#     print(f"mux32 #(.N(1)) MUX32_{i}(",end='')
#     for j in range(32):
#         r = 31-i-j
#         if r >= 0:
#             print(f".in{str(j).zfill(2)}(in[{r}])," ,end='') 
#         else:
#             print(f".in{str(j).zfill(2)}(1'b0)," ,end='') 
#     print(f".select(shamt),.out(out[{31-i}]));")


# for i in reversed(range(32)):
#     print(f"mux32 #(.N(1)) MUX32_{i}(",end='')
#     for j in range(32):
#         r = j+i
#         if r < 32:
#             print(f".in{str(j).zfill(2)}(in[{r}])," ,end='') 
#         else:
#             print(f".in{str(j).zfill(2)}(1'b0)," ,end='') 
#     print(f".select(shamt),.out(out[{i}]));")

print("mux32 #(.N(N)) MUX32(.in00(in),",end='')
for i in range(1,32):
    print(f" .in{str(i).zfill(2)}({{in[N-{i+1}:0], {{{i}{{1'b0}}}}}}),",end='')
print(".select(shamt), .out(out));")

# print("mux32 #(.N(N)) MUX32(.in00(in),",end='')
# for i in range(1,32):
#     print(f" .in{str(i).zfill(2)}({{{{{i}{{in[N-1]}}}}, in[N-1:{i}]}}),",end='')
# print(".select(shamt), .out(out));")

# print("mux32 #(.N(N)) MUX32(.in00(in),",end='')
# for i in range(1,32):
#     print(f" .in{str(i).zfill(2)}({{{{{i}{{1'b0}}}}, in[N-1:{i}]}}),",end='')
# print(".select(shamt), .out(out));")