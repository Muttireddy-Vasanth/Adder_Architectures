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


// Full Adder - Gate Level Modelling (carry = ab + c(a^b))
module Full_Adder_GateLevel2(input a, b, c,
                            output sum, carry);

    wire w0, w1, w2;

    xor X0(sum, a, b, c);
    and A0(w0, a, b);
    xor X1(w1, a, b);
    and A2(w2, c, w1);
    or  O0(carry, w0, w2);

endmodule


// Full Adder - Dataflow Modelling (carry = ab + bc + ca)
module Full_Adder_Dataflow1(input a, b, c,
                            output sum, carry);

    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (c & a);

endmodule


// Full Adder - Dataflow Modelling (carry = ab + c(a^b))
module Full_Adder_Dataflow2(input a, b, c,
                            output sum, carry);

    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (c & (a ^ b));

endmodule


// Full Adder - Dataflow Modelling (using arithmetic operator)
module Full_Adder_Arithmetic(input a, b, c,
                             output sum, carry);

    assign {carry, sum} = a + b + c;

endmodule


// Full Adder - Behavioral Modelling (carry = ab + bc + ca)
module Full_Adder_Behavioral1(input a, b, c,
                              output reg sum, carry);

    always @(*) begin
        sum = a ^ b ^ c;
        carry = (a & b) | (b & c) | (c & a);
    end

endmodule

// Full Adder - Behavioral Modelling (carry = ab + c(a^b))
module Full_Adder_Behavioral2(input a, b, c,
                              output reg sum, carry);

    always @(*) begin
        sum = a ^ b ^ c;
        carry = (a & b) | (c & (a ^ b));
    end

endmodule



// Full Adder - User Defined Primitive (UDP)
module Full_Adder_UDP(input a, b, c,
                      output sum, carry);

    full_adder_prim FA1(sum, carry, a, b, c);

endmodule

primitive full_adder_prim(sum, carry, a, b, c);
    input a, b, c;
    output sum, carry;

    table
    // a b c : sum carry
      0 0 0 :  0   0;
      0 0 1 :  1   0;
      0 1 0 :  1   0;
      0 1 1 :  0   1;
      1 0 0 :  1   0;
      1 0 1 :  0   1;
      1 1 0 :  0   1;
      1 1 1 :  1   1;
    endtable
endprimitive

