//This project consists of 1-bit Full Adder, 4-bit Ripple carry adder, Carry select adder

module Carry_Select_Adder(
    input  [15:0] A, B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire c1, c2, c3;          // carries between blocks

    wire [3:0] sum0_1, sum1_1, sum0_2, sum1_2, sum0_3, sum1_3;
    wire c0_1, c1_1, c0_2, c1_2, c0_3, c1_3;

    // First 4 bits (direct ripple carry with Cin)
    Ripple_Carry_Adder RCA0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .c(Cin),
        .Sum(Sum[3:0]),
        .Carry(c1)
    );

    // Second 4 bits carry = 0 case
    Ripple_Carry_Adder RCA1_c0 (
        .A(A[7:4]),
        .B(B[7:4]),
        .c(1'b0),
        .Sum(sum0_1),
        .Carry(c0_1)
    );
    // Second 4 bits carry = 1 case
    Ripple_Carry_Adder RCA1_c1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .c(1'b1),
        .Sum(sum1_1),
        .Carry(c1_1)
    );
    // Select sum and carry via mux
    assign Sum[7:4] = (c1) ? sum1_1 : sum0_1;
    assign c2 = (c1) ? c1_1 : c0_1;

    // Third 4 bits carry = 0 case
    Ripple_Carry_Adder RCA2_c0 (
        .A(A[11:8]),
        .B(B[11:8]),
        .c(1'b0),
        .Sum(sum0_2),
        .Carry(c0_2)
    );
    // Third 4 bits carry = 1 case
    Ripple_Carry_Adder RCA2_c1 (
        .A(A[11:8]),
        .B(B[11:8]),
        .c(1'b1),
        .Sum(sum1_2),
        .Carry(c1_2)
    );
    // Select sum and carry via mux
    assign Sum[11:8] = (c2) ? sum1_2 : sum0_2;
    assign c3 = (c2) ? c1_2 : c0_2;

    // Fourth 4 bits carry = 0 case
    Ripple_Carry_Adder RCA3_c0 (
        .A(A[15:12]),
        .B(B[15:12]),
        .c(1'b0),
        .Sum(sum0_3),
        .Carry(c0_3)
    );
    // Fourth 4 bits carry = 1 case
    Ripple_Carry_Adder RCA3_c1 (
        .A(A[15:12]),
        .B(B[15:12]),
        .c(1'b1),
        .Sum(sum1_3),
        .Carry(c1_3)
    );
    // Select sum and carry via mux
    assign Sum[15:12] = (c3) ? sum1_3 : sum0_3;
    assign Cout = (c3) ? c1_3 : c0_3;

endmodule


module Ripple_Carry_Adder(
    input  [3:0] A, B,
    input        c,
    output [3:0] Sum,
    output       Carry
);

    wire c1, c2, c3;  // internal carry wires

    // Instantiate full adders for each bit
    Full_Adder FA0 (
        .a(A[0]),
        .b(B[0]),
        .c(c),
        .sum(Sum[0]),
        .carry(c1)
    );

    Full_Adder FA1 (
        .a(A[1]),
        .b(B[1]),
        .c(c1),
        .sum(Sum[1]),
        .carry(c2)
    );

    Full_Adder FA2 (
        .a(A[2]),
        .b(B[2]),
        .c(c2),
        .sum(Sum[2]),
        .carry(c3)
    );

    Full_Adder FA3 (
        .a(A[3]),
        .b(B[3]),
        .c(c3),
        .sum(Sum[3]),
        .carry(Carry)
    );

endmodule

module Full_Adder(
    input  a,
    input  b,
    input  c,
    output sum,
    output carry
);

    assign sum = a ^ b ^ c;               // sum = a XOR b XOR c
    assign carry = (a & b) | (b & c) | (a & c);  // carry = majority of inputs

endmodule
