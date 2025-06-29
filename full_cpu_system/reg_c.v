
`timescale 1ns / 1ps

module reg_c (
    input         clk,
    input         rst_n,
    input         load,
    input  signed [15:0] data_in,
    output reg signed [15:0] data_out
);

    always @(posedge clk) begin
        if (!rst_n)
            data_out <= 16'sd0;
        else if (load)
            data_out <= data_in;
    end

endmodule
