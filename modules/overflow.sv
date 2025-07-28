module overflow (
    input wire a,
    input wire b, 
    input wire z,
    output wire overflow
);

// overflow = z'ab + za'b'
// overflow = 1 if z = 0 when ab = 11
// overflow = 1 if z = 1 when ab = 00

//Intermediate signals
wire ab, ab_n, a_n, b_n, z_n, zab_n, z_nab;

//Gate-level logic
not (a_n, a);	       //a'
not (b_n, b);	       //b'
not (z_n, z);	       //z'
and (ab_n, a_n, b_n);  //a'b'
and (ab, a, b);	       //ab
and (zab_n, z, ab_n);  //za'b'
and (z_nab, z_n, ab);  //z'ab
or  (overflow, z_nab, zab_n); //z'ab + za'b'

endmodule