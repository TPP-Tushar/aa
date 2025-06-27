module alu_arithmetic (
    input  [3:0]  opcode,
    input  signed [15:0] a,
    input  signed [15:0] b,
    output reg signed [15:0] out,
    output reg carry,
    output reg overflow,
    output reg sign
);
    always @(*) begin
        out = 0; carry = 0; overflow = 0; sign = 0;
        case (opcode)
            4'b0100: begin
                {carry, out} = a + b;
                overflow = (~a[15] & ~b[15] & out[15]) | (a[15] & b[15] & ~out[15]);
            end
            4'b0101: begin
                {carry, out} = a - b;
                overflow = (a[15] & ~b[15] & ~out[15]) | (~a[15] & b[15] & out[15]);
            end
        endcase
        sign = out[15];
    end
endmodule
