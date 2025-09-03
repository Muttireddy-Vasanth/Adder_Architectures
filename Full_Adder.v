// Full Adder - Gate Level Modelling (carry = ab + bc + ca)
module Full_Adder_GateLevel1(input a, b, c,
                            output sum, carry);

    wire w0, w1, w2;

    xor X0(sum, a, b, c);
    and A0(w0, a, b);
    and A1(w1, b, c);
    and A2(w2, c, a);
    or  O0(carry, w0, w1, w2);

endmodule
