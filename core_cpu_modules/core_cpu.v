module core_cpu (
    input         clk,
    input         rst_n,
    input  [19:0] data_in,
    output [7:0]  data_out,
    output        flag_carry,
    output        flag_sign,
    output        flag_OverFlow
);
    wire [3:0]  opcode = data_in[19:16];
    wire signed [15:0] operand = data_in[15:0];

    wire signed [15:0] reg_a_out, reg_b_out, alu_result;
    wire signed [15:0] reg_c_out;

    wire load_a, load_b, load_c, enable_out;
    wire carry, sign, overflow;

    reg [1:0] out_cycle = 0;
    reg [7:0] data_out_reg;

    controller ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .opcode(opcode),
        .load_a(load_a),
        .load_b(load_b),
        .load_c(load_c),
        .enable_out(enable_out)
    );

    reg_a u_reg_a (.clk(clk), .rst_n(rst_n), .load(load_a), .data_in(operand), .data_out(reg_a_out));
    reg_b u_reg_b (.clk(clk), .rst_n(rst_n), .load(load_b), .data_in(operand), .data_out(reg_b_out));
    reg_c u_reg_c (.clk(clk), .rst_n(rst_n), .load(load_c), .data_in(alu_result), .data_out(reg_c_out));

    alu u_alu (
        .opcode(opcode),
        .a(reg_a_out),
        .b(reg_b_out),
        .result(alu_result),
        .carry(carry),
        .sign(sign),
        .overflow(overflow)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_cycle <= 0;
            data_out_reg <= 0;
        end else if (enable_out) begin
            out_cycle <= out_cycle + 1;
            case (out_cycle)
                0: data_out_reg <= reg_c_out[15:8];
                1: data_out_reg <= reg_c_out[7:0];
                default: out_cycle <= 0;
            endcase
        end
    end

    assign data_out = data_out_reg;
    assign flag_carry = carry;
    assign flag_sign = sign;
    assign flag_OverFlow = overflow;
endmodule
