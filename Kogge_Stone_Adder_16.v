`timescale 1ns / 1ps

//============================================================
// Pre_Process module
// Calculates Generate (g) and Propagate (p) signals from inputs A and B
// g = A & B, p = A ^ B
//============================================================
module Pre_Process(
    output g,
    output p,
    input  A,
    input  B
);
    assign g = A & B;
    assign p = A ^ B;
endmodule


//============================================================
// Black_Dot module (Prefix operator)
// Performs the parallel prefix operation on two generate-propagate pairs:
// (G,P) • (G',P') = (G + P*G', P*P')
//============================================================
module Black_Dot(
    output Gout,
    output Pout,
    input  Gin,
    input  Pin,
    input  Gin1,
    input  Pin1
);
    assign Gout = Gin | (Pin & Gin1);
    assign Pout = Pin & Pin1;
endmodule


//============================================================
// Sum_Generate module
// Calculates carry output for a bit given generate, propagate and carry-in:
//
// Carry_out = G + P * Cin
//============================================================
module Sum_Generate(
    output Carry_out,
    input  G,
    input  P,
    input  Cin
);
    assign Carry_out = G | (P & Cin);
endmodule

//============================================================
// 8-bit Kogge-Stone Adder
// Performs fast parallel prefix addition using generate and propagate signals
//============================================================
module Kogge_Stone_Adder_8(
    output [7:0] Sum,
    output       Carry,
    input  [7:0] A,
    input  [7:0] B,
    input        Cin
);
    wire [7:0] p, g;         // Propagate and Generate signals for each bit
    wire [6:0] Cout;         // Carry outputs for bits 1 to 7
    wire [7:1] P, G;         // Intermediate generate and propagate signals
    wire [9:0] u, v;         // Internal wires for prefix computation

    // Preprocessing: Calculate bitwise propagate and generate signals
    Pre_Process S0 (g[0], p[0], A[0], B[0]);
    Pre_Process S1 (g[1], p[1], A[1], B[1]);
    Pre_Process S2 (g[2], p[2], A[2], B[2]);
    Pre_Process S3 (g[3], p[3], A[3], B[3]);
    Pre_Process S4 (g[4], p[4], A[4], B[4]);
    Pre_Process S5 (g[5], p[5], A[5], B[5]);
    Pre_Process S6 (g[6], p[6], A[6], B[6]);
    Pre_Process S7 (g[7], p[7], A[7], B[7]);

    // Prefix computation using black dots (carry-lookahead operators)
    // (G,P) dot (G`,P`) = (G + P*G`, P*P`)
    Black_Dot D1  (G[1],  P[1],  g[1],  p[1],  g[0],  p[0]);
    Black_Dot D2  (u[0],  v[0],  g[2],  p[2],  g[1],  p[1]);
    Black_Dot D3  (G[2],  P[2],  u[0],  v[0],  g[0],  p[0]);
    Black_Dot D4  (u[1],  v[1],  g[3],  p[3],  g[2],  p[2]);
    Black_Dot D5  (G[3],  P[3],  u[1],  v[1],  G[1],  P[1]);
    Black_Dot D6  (u[2],  v[2],  g[4],  p[4],  g[3],  p[3]);
    Black_Dot D7  (u[3],  v[3],  u[2],  v[2],  u[0],  v[0]);
    Black_Dot D8  (G[4],  P[4],  u[3],  v[3],  g[0],  p[0]);
    Black_Dot D9  (u[4],  v[4],  g[5],  p[5],  g[4],  p[4]);
    Black_Dot D10 (u[5],  v[5],  u[4],  v[4],  u[1],  v[1]);
    Black_Dot D11 (G[5],  P[5],  u[5],  v[5],  G[1],  P[1]);
    Black_Dot D12 (u[6],  v[6],  g[6],  p[6],  g[5],  p[5]);
    Black_Dot D13 (u[7],  v[7],  u[6],  v[6],  u[2],  v[2]);
    Black_Dot D14 (G[6],  P[6],  u[7],  v[7],  G[2],  P[2]);
    Black_Dot D15 (u[8],  v[8],  g[7],  p[7],  g[6],  p[6]);
    Black_Dot D16 (u[9],  v[9],  u[8],  v[8],  u[4],  v[4]);
    Black_Dot D17 (G[7],  P[7],  u[9],  v[9],  G[3],  P[3]);

    // Carry generation using sum_generate blocks:
    // Ci+1 = Gi + Pi*Cin
    Sum_Generate x0 (Cout[0], g[0],  p[0],  Cin);
    Sum_Generate x1 (Cout[1], G[1],  P[1],  Cin);
    Sum_Generate x2 (Cout[2], G[2],  P[2],  Cin);
    Sum_Generate x3 (Cout[3], G[3],  P[3],  Cin);
    Sum_Generate x4 (Cout[4], G[4],  P[4],  Cin);
    Sum_Generate x5 (Cout[5], G[5],  P[5],  Cin);
    Sum_Generate x6 (Cout[6], G[6],  P[6],  Cin);
    Sum_Generate x7 (Carry,   G[7],  P[7],  Cin);

    // Sum bits calculation: Si = Pi XOR Ci
    assign Sum[0] = p[0] ^ Cin;
    genvar i;
    generate
        for(i = 1; i < 8; i = i + 1) begin : sum_loop
            assign Sum[i] = p[i] ^ Cout[i-1];
        end
    endgenerate

endmodule

//============================================================
// 16-bit Kogge-Stone Adder
// Performs addition or subtraction depending on Cin as control
//============================================================
module Kogge_Stone_Adder_16(
    output [15:0] Sum,
    output        Carry,
    input  [15:0] A,
    input  [15:0] B,
    input         Cin
);
    wire w1;
    wire [15:0] B_xor;

    // Invert B if performing subtraction (Cin=1), else add normally
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : b_xor_loop
            xor(b_xor[i], B[i], Cin);
        end
    endgenerate

    // Instantiate lower 8-bit Kogge-Stone Adder with adjusted B and carry in
    Kogge_Stone_Adder_8 ksa1 (
        .Sum(Sum[7:0]),
        .Carry(w1),
        .A(A[7:0]),
        .B(B_xor[7:0]),
        .Cin(Cin)
    );

    // Instantiate higher 8-bit Kogge-Stone Adder with adjusted B and carry from lower block
    Kogge_Stone_Adder_8 ksa2 (
        .Sum(Sum[15:8]),
        .Carry(Carry),
        .A(A[15:8]),
        .B(B_xor[15:8]),
        .Cin(w1)
    );

endmodule
