`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:26:31
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input wire [31:0]a,
    input wire [31:0]b,
    input wire [2:0]f,
    output wire [31:0]y,
    output wire overflow,
    output wire zero
    );

    assign y =  (f==3'b000) ? a + b:
                (f==3'd1) ? a - b:
                (f==3'd2) ? a & b:
                (f==3'd3) ? a | b:
                (f==3'd4) ? ~a:
                (f==3'd5) ? a < b:
                32'b0;
    assign zero = (y == 32'b0);
    // always @(*) begin
    //     case (f)
    //         3'b000:  begin
    //             y <= a + b;
    //         end
    //         3'b001:  begin
    //             y <= a - b;
    //         end
    //         3'b010:  begin
    //             y <= a & b;
    //         end
    //         3'b011:  begin
    //             y <= a | b;
    //         end
    //         3'b100:  begin
    //             y <= ~a;
    //         end
    //         3'b101:  begin
    //             y <= a < b;
    //         end
    //         default: begin
    //             y <= 32'b0;
    //         end
    //     endcase
    // end

endmodule
