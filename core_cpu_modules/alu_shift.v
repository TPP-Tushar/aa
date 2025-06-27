module alu_shift (
    input  [3:0]  opcode,
    input  signed [15:0] a,
    output reg signed [15:0] out
);
    always @(*) begin
        case (opcode)
            4'b0110: out = a <<< 1;
            4'b0111: out = a >>> 1;
            default: out = 16'sd0;
        endcase
    end
endmodule
