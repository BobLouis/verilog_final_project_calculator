module num2bcd(clk,num);
    input clk;
    input [31:0] num;
    reg old_num;
    reg [3:0]num1;
    reg [3:0]num2;
    reg [3:0]num3;
    reg [3:0]num4;
    reg [3:0]num5;
    reg [3:0]num6;
    reg [3:0]num7;
    reg [3:0]num8;
    reg [3:0]num9;
    reg [3:0]num10;

    reg [3:0]tmp_num1;
    reg [3:0]tmp_num2;
    reg [3:0]tmp_num3;
    reg [3:0]tmp_num4;
    reg [3:0]tmp_num5;
    reg [3:0]tmp_num6;
    reg [3:0]tmp_num7;
    reg [3:0]tmp_num8;
    reg [3:0]tmp_num9;
    reg [3:0]tmp_num10;
    reg [5:0]i;
    reg [71:0]shift_reg;    
     
     //Always block - implement the Double Dabble algorithm
     always @(posedge clk)
        begin
            //initialize bcd to zero.
            if(i == 6'd0 && (old_num != num))
            begin
                shift_reg <= 72'd0;
                old_num <= num;
                shift_reg[31:0] <= num;
                i <= i + 6'd1;
            end
            else if(i<33 && i>0)
            begin
                if(tmp_num10 >= 5) tmp_num10 <= tmp_num10 + 4'd3;
                if(tmp_num9 >= 5) tmp_num9 <= tmp_num9 + 4'd3;
                if(tmp_num8 >= 5) tmp_num8 <= tmp_num8 + 4'd3;
                if(tmp_num7 >= 5) tmp_num7 <= tmp_num7 + 4'd3;
                if(tmp_num6 >= 5) tmp_num6 <= tmp_num6 + 4'd3;
                if(tmp_num5 >= 5) tmp_num5 <= tmp_num5 + 4'd3;
                if(tmp_num4 >= 5) tmp_num4 <= tmp_num4 + 4'd3;
                if(tmp_num3 >= 5) tmp_num3 <= tmp_num3 + 4'd3;
                if(tmp_num2 >= 5) tmp_num2 <= tmp_num2 + 4'd3;
                if(tmp_num1 >= 5) tmp_num1 <= tmp_num1 + 4'd3;

                shift_reg [71:32] <= {tmp_num10,tmp_num9,tmp_num8,tmp_num7,tmp_num6,tmp_num5,tmp_num4,tmp_num3,tmp_num2,tmp_num1};
                shift_reg <= shift_reg << 1;
                tmp_num10 <= shift_reg[71:68];
                tmp_num9 <= shift_reg[67:64];
                tmp_num8 <= shift_reg[63:60];
                tmp_num7 <= shift_reg[59:56];
                tmp_num6 <= shift_reg[55:52];
                tmp_num5 <= shift_reg[51:48];
                tmp_num4 <= shift_reg[47:44];
                tmp_num3 <= shift_reg[43:40];
                tmp_num2 <= shift_reg[39:36];
                tmp_num1 <= shift_reg[35:32];
                i <= i + 6'd1;
            end
            else
            begin
                i <= 6'd0;
                num10 <= tmp_num10;
                num9 <= tmp_num9;
                num8 <= tmp_num8;
                num7 <= tmp_num7;
                num6 <= tmp_num6;
                num5 <= tmp_num5;
                num4 <= tmp_num4;
                num3 <= tmp_num3;
                num2 <= tmp_num2;
                num1 <= tmp_num1;
            end
        end             
endmodule