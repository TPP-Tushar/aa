
`timescale 1ns / 1ps

module top_wrapper_tb;

    reg  [15:0] data_in_from_pad;
    reg         clk_from_pad;
    reg         rst_n_from_pad;
    reg  [3:0]  bidir_inputs_from_pad;

    wire [15:0] pu_data_in;
    wire [15:0] pd_data_in;
    wire        pu_clk;
    wire        pd_clk;
    wire        pu_rst_n;
    wire        pd_rst_n;
    wire [14:0] oe_bidir;
    wire [14:0] ie_bidir;
    wire [14:0] pu_bidir;
    wire [14:0] pd_bidir;
    wire [10:0] bidir_output_data;

    integer cycle;

    top_wrapper dut (
        .data_in_from_pad      (data_in_from_pad),
        .clk_from_pad          (clk_from_pad),
        .rst_n_from_pad        (rst_n_from_pad),
        .bidir_inputs_from_pad (bidir_inputs_from_pad),
        .pu_data_in            (pu_data_in),
        .pd_data_in            (pd_data_in),
        .pu_clk                (pu_clk),
        .pd_clk                (pd_clk),
        .pu_rst_n              (pu_rst_n),
        .pd_rst_n              (pd_rst_n),
        .oe_bidir              (oe_bidir),
        .ie_bidir              (ie_bidir),
        .pu_bidir              (pu_bidir),
        .pd_bidir              (pd_bidir),
        .bidir_output_data     (bidir_output_data)
    );

    initial begin
        clk_from_pad = 0;
        forever #5 clk_from_pad = ~clk_from_pad;
    end

    initial begin
        $dumpfile("neg_sub.vcd");
        $dumpvars(0, top_wrapper_tb);
    end

    always @(posedge clk_from_pad) begin
        if (rst_n_from_pad) begin
            cycle = cycle + 1;
            $display("[Time %0t] Cycle: %0d | Data Out: %b | Flags: C=%b S=%b V=%b",
                $time, cycle,
                bidir_output_data[7:0],
                bidir_output_data[10],
                bidir_output_data[9],
                bidir_output_data[8]
            );
        end
    end

    initial begin
        cycle = 0;
        rst_n_from_pad = 0;
        data_in_from_pad = 16'b0;
        bidir_inputs_from_pad = 4'b0;
        #20;

        rst_n_from_pad = 1;
        $display("=== Negative SUB Operation Test ===");

        data_in_from_pad = 16'h0005;
        bidir_inputs_from_pad = 4'b0001; // LOADA
        #10;

        data_in_from_pad = 16'h000A;
        bidir_inputs_from_pad = 4'b0010; // LOADB
        #10;

        data_in_from_pad = 16'h0000;
        bidir_inputs_from_pad = 4'b0101; // SUB
        #10;

        data_in_from_pad = 16'h0000;
        bidir_inputs_from_pad = 4'b0011; // READOUT
        #20;

        $display("=== Test Done ===");
        $finish;
    end

endmodule
