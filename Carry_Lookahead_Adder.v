//Carry_Lookahead_Adder which calculates carry reducing the time for computation in each step

module Carry_Lookahead_Adder(
    input  [15:0] A, B,
    input         Cin,
    output [15:0] Sum,
    output        Carry
);

    wire [15:0] P, G;   // Propagate and Generate signals
    wire [16:0] C;      // Carry signals, C[0] = Cin

    assign C[0] = Cin;

    // Calculate Propagate (P) and Generate (G) signals for each bit
    assign P = A ^ B;       // Propagate = A XOR B
    assign G = A & B;       // Generate = A AND B

    // Carry lookahead logic (carry generation)
    assign C[1]  = G[0]  | (P[0]  & C[0]);
    assign C[2]  = G[1]  | (P[1]  & G[0])  | (P[1] & P[0]  & C[0]);
    assign C[3]  = G[2]  | (P[2]  & G[1])  | (P[2] & P[1] & G[0])   | (P[2] & P[1] & P[0]  & C[0]);
    assign C[4]  = G[3]  | (P[3]  & G[2])  | (P[3] & P[2] & G[1])   | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0]  & C[0]);

    assign C[5]  = G[4]  | (P[4]  & G[3])  | (P[4] & P[3] & G[2])   | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6]  = G[5]  | (P[5]  & G[4])  | (P[5] & P[4] & G[3])   | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7]  = G[6]  | (P[6]  & G[5])  | (P[6] & P[5] & G[4])   | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[8]  = G[7]  | (P[7]  & G[6])  | (P[7] & P[6] & G[5])   | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    // Similarly for bits 9 to 15:

    assign C[9] = G[8] | (P[8] & C[8]);
    assign C[10] = G[9] | (P[9] & G[8]) | (P[9] & P[8] & C[8]);
    assign C[11] = G[10] | (P[10] & G[9]) | (P[10] & P[9] & G[8]) | (P[10] & P[9] & P[8] & C[8]);
    assign C[12] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9]) | (P[11] & P[10] & P[9] & G[8]) | (P[11] & P[10] & P[9] & P[8] & C[8]);

    assign C[13] = G[12] | (P[12] & G[11]) | (P[12] & P[11] & G[10]) | (P[12] & P[11] & P[10] & G[9]) | (P[12] & P[11] & P[10] & P[9] & G[8]) | (P[12] & P[11] & P[10] & P[9] & P[8] & C[8]);
    assign C[14] = G[13] | (P[13] & G[12]) | (P[13] & P[12] & G[11]) | (P[13] & P[12] & P[11] & G[10]) | (P[13] & P[12] & P[11] & P[10] & G[9]) | (P[13] & P[12] & P[11] & P[10] & P[9] & G[8]) | (P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & C[8]);
    assign C[15] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & G[12]) | (P[14] & P[13] & P[12] & G[11]) | (P[14] & P[13] & P[12] & P[11] & G[10]) | (P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & G[8]) | (P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & C[8]);

    assign C[16] = G[15] | (P[15] & C[15]);

    // Calculate Sum bits
    assign Sum = P ^ C[15:0];

    // Carry out
    assign Carry = C[16];

endmodule
