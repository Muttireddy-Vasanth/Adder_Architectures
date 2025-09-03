// Half Adder using Gate-Level Modelling
module Half_Adder_GateLevel(input a, b,
                           output sum, carry);

    xor X1(sum, a, b);
    and A1(carry, a, b);

endmodule


// Half Adder using Dataflow Modelling (bitwise operators)
module Half_Adder_Dataflow_Bitwise(input a, b,
                                   output sum, carry);

    assign sum = a ^ b;
    assign carry = a & b;

endmodule



// Half Adder using Dataflow Modelling (arithmetic operator)
module Half_Adder_Dataflow_Arithmetic(input a, b,
                                      output sum, carry);

    assign {carry, sum} = a + b;

endmodule



// Half Adder using Behavioral Modelling
module Half_Adder_Behavioral(input a, b,
                             output reg sum, carry);

    always @(*) begin
        sum = a ^ b;
        carry = a & b;
    end

endmodule




// Half Adder using User Defined Primitive (UDP)
module Half_Adder_UDP(input a, b,
                      output sum, carry);

    half_adder_prim HA1(sum, carry, a, b);

endmodule

primitive half_adder_prim(sum, carry, a, b);
    input a, b;
    output sum, carry;

    table
        // a b : sum carry
           0 0 : 0   0;
           0 1 : 1   0;
           1 0 : 1   0;
           1 1 : 0   1;
    endtable
endprimitive
