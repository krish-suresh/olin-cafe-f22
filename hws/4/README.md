# Homework 4
The written portion is available [here](https://docs.google.com/document/d/1XybXmTD5-NTJ1gfLq3tYb-wUUDJGZS8xgO912DLf50Q/edit?usp=sharing)

Add a pdf of your written answers to this folder, then use `make clean` then `make submission` to submit!



## 3. ALU

### MUX32
In order to implement a 32 bit select mux, I started with breaking the problem down into smaller and smaller muxes. Each of the bits starting from the left represent a decision between half of the inputs so each bit can be represented by a single 1 bit mux with the inputs of the mux being the output of the smaller mux problem. For example, the 32 bit mux is split into two 16 bit muxes and a following 1 bit mux, the 16 bit mux is split into two 8 bit muxes and so on. 

After implementing the mux, the testing was completed by setting each of the input buses to their corresponding selection value as a 5 bit input to represent each of the 32 inputs. Then we can loop through each of the selects and validate the mux by checking that the output is the same as the selected number.

To run the test, make the test script with:

```make test_mux32```

### ADD32
