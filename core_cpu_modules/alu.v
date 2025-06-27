module alu (
    input  [3:0]  opcode,
    input  signed [15:0] a,
    input  signed [15:0] b,
    output reg signed [15:0] result,
    output reg carry,
    output reg sign,
    output reg overflow
);
    wire signed [15:0] arithmetic_out, shift_out, logical_out;
    wire ac, ao, as;

    alu_arithmetic u_arith (.opcode(opcode), .a(a), .b(b), .out(arithmetic_out), .carry(ac), .overflow(ao), .sign(as));
    alu_shift      u_shift (.opcode(opcode), .a(a), .out(shift_out));
    alu_logical    u_logic (.opcode(opcode), .a(a), .b(b), .out(logical_out));

    always @(*) begin
        carry = 0; overflow = 0; sign = 0;
        case (opcode)
            4'b0100, 4'b0101: begin
                result   = arithmetic_out;
                carry    = ac;
                overflow = ao;
                sign     = as;
            end
            4'b0110, 4'b0111: begin
                result = shift_out;
                sign   = shift_out[15];
            end
            4'b1000, 4'b1001, 4'b1010,
            4'b1011, 4'b1100, 4'b1101: begin
                result = logical_out;
                sign   = logical_out[15];
            end
            default: result = 16'sd0;
        endcase
    end
endmodule
