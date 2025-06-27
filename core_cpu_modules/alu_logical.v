module alu_logical (
    input  [3:0]  opcode,
    input  signed [15:0] a,
    input  signed [15:0] b,
    output reg signed [15:0] out
);
    always @(*) begin
        case (opcode)
            4'b1000: out = a & b;
            4'b1001: out = a | b;
            4'b1010: out = ~(a & b);
            4'b1011: out = ~(a | b);
            4'b1100: out = ~a;
            4'b1101: out = a ^ b;
            default: out = 16'sd0;
        endcase
    end
endmodule
