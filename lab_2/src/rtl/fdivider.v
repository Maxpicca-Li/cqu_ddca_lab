`timescale 1ns/1ps
module fdivider (
    input wire clk,
    input wire [31:0]rate,
    output wire myclk 
    ); 
    // 注意：rate，表示f_new比f_clk慢多少，即rate = f_clk / f_new
    reg inlineclk=1'b0; // 注意：一定要初始化
    reg [31:0]cnt = 1'b1;
    wire [31:0]half_rate;
    // assign half_rate = rate >> 1'b0; // 右移动1位，除以2，正负翻转是在半周期
    assign half_rate = rate >> 2; // 右移动2位，除以4，posedge clk,一个周期，clk只翻转一次
    assign myclk = inlineclk;

    // done_FIXME 仿真的时候，时间还是会延迟1ns
    // ==> 这里的cnt一直要保持+1的状态，而不只是在else中执行
    always@(posedge clk) begin  // 方法一
        if(cnt == half_rate) begin
            inlineclk <= ~inlineclk;
            cnt <= 1'b1; 
        end
        else begin cnt <= cnt + 1'b1;end
    end
    
    // always@(clk) begin  // 方法二  
    //     if(cnt == half_rate) begin
    //         inlineclk = 1'b0;
    //     end else if (cnt==rate) begin 
    //         inlineclk = 1'b1;
    //         cnt = 1'b0; 
    //     end
    //     cnt = cnt + 1'b1;
    // end

endmodule