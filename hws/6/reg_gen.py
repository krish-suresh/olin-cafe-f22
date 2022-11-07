for i in range(32):
    r = str(i).zfill(2)
    addr = format(i, '05b')
    print(f'''  x{r} <= (&(wr_addr ~^ 5'b{addr}) & wr_ena) ? wr_data : x{r};''')
#   rd0x{r} <= &(rd_addr0 ~^ 5'b{addr}) ? x{r} : 0;
#   rd1x{r} <= &(rd_addr1 ~^ 5'b{addr}) ? x{r} : 0;