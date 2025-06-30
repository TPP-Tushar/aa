
module controller (
    input  [3:0] opcode,
    output reg load_a,
    output reg load_b,
    output reg load_c,
    output reg read_en
);
    always @(*) begin
        load_a  = 0;
        load_b  = 0;
        load_c  = 0;
        read_en = 0;

        case (opcode)
            4'b0001: load_a  = 1; // LOADA
            4'b0010: load_b  = 1; // LOADB
            4'b0100, 4'b0101, 4'b0110, 4'b0111,
            4'b1000, 4'b1001, 4'b1010, 4'b1011,
            4'b1100, 4'b1101: load_c = 1;
            4'b0011: read_en = 1; // READOUT
        endcase
    end
endmodule
