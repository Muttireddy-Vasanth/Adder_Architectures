module CLA_4bit(
    input  [3:0] A, B,
    input        Cin,
    output [3:0] Sum,
    output       Cout,
    output       Pgroup,
    output       Ggroup
);
    wire [3:0] P, G;
    wire [4:0] C;

    assign C[0] = Cin;
    assign P = A ^ B;    // Propagate
    assign G = A & B;    // Generate

    // Carry lookahead equations for 4 bits
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Group Propagate and Generate for upper-level CLA
    assign Pgroup = &P;             // Pgroup = P0 & P1 & P2 & P3
    assign Ggroup = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

    assign Sum = P ^ C[3:0];  // Sum bits
    assign Cout = C[4];
endmodule


module CarryLookahead_16bit(
    input  [15:0] A, B,
    input         Cin,
    output [15:0] Sum,
    output        Carry
);
    wire [3:0] Pgroup, Ggroup;   // Group propagate and generate for each 4-bit block
    wire [4:0] C;                // Carry signals between blocks

    assign C[0] = Cin;

    // Instantiate 4-bit CLAs
    CLA_4bit CLA0 (A[3:0],  B[3:0],  C[0],  Sum[3:0],  C[1], Pgroup[0], Ggroup[0]);
    CLA_4bit CLA1 (A[7:4],  B[7:4],  C[1],  Sum[7:4],  C[2], Pgroup[1], Ggroup[1]);
    CLA_4bit CLA2 (A[11:8], B[11:8], C[2],  Sum[11:8], C[3], Pgroup[2], Ggroup[2]);
    CLA_4bit CLA3 (A[15:12],B[15:12],C[3],  Sum[15:12], C[4], Pgroup[3], Ggroup[3]);

    // Upper level carry lookahead for 4 groups
    assign C[1] = Ggroup[0] | (Pgroup[0] & C[0]);
    assign C[2] = Ggroup[1] | (Pgroup[1] & Ggroup[0]) | (Pgroup[1] & Pgroup[0] & C[0]);
    assign C[3] = Ggroup[2] | (Pgroup[2] & Ggroup[1]) | (Pgroup[2] & Pgroup[1] & Ggroup[0]) | (Pgroup[2] & Pgroup[1] & Pgroup[0] & C[0]);
    assign C[4] = Ggroup[3] | (Pgroup[3] & Ggroup[2]) | (Pgroup[3] & Pgroup[2] & Ggroup[1]) | (Pgroup[3] & Pgroup[2] & Pgroup[1] & Ggroup[0]) | (Pgroup[3] & Pgroup[2] & Pgroup[1] & Pgroup[0] & C[0]);

    assign Carry = C[4];
endmodule
