// 16-bit Ripple Carry Adder using Full Adders
module Ripple_Carry_Adder(
    input  [15:0] A, B,
    input         c,        // input carry
    output [15:0] Sum,
    output        Carry     // final carry out
);

    wire [14:0] C;           // internal carries between adders

    // First full adder with input carry
    Full_Adder FA0 (
        .a(A[0]),
        .b(B[0]),
        .c(c),
        .sum(Sum[0]),
        .carry(C[0])
    );

    // Generate full adders for bits 1 to 14
    genvar i;
    generate
        for (i = 1; i < 15; i = i + 1) begin : gen_adders
            Full_Adder FA (
                .a(A[i]),
                .b(B[i]),
                .c(C[i-1]),
                .sum(Sum[i]),
                .carry(C[i])
            );
        end
    endgenerate

    // Last full adder for bit 15, carry output is final Carry
    Full_Adder FA15 (
        .a(A[15]),
        .b(B[15]),
        .c(C[14]),
        .sum(Sum[15]),
        .carry(Carry)
    );

endmodule
