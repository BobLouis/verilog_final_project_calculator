module num2bcd(num);
    input [31:0] num;
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
    reg [5:0]i;   
     
     //Always block - implement the Double Dabble algorithm
     always @(num)
        begin
            //initialize bcd to zero.
            num1 = 4'b0;
            num2 = 4'b0;
            num3 = 4'b0;
            num4 = 4'b0;
            num5 = 4'b0;
            num6 = 4'b0;
            num7 = 4'b0;
            num8 = 4'b0;
            num9 = 4'b0;
            num10 = 4'b0;
            for (i = 0; i < 32; i = i+1) //run for 8 iterations
            begin
                //if a hex digit of 'bcd' is more than 4, add 3 to it.
                if(num1[3:0] > 4'd4) 
                    num1[3:0] = num1[3:0] + 3;
                if(num2[3:0] > 4'd4) 
                    num2[3:0] = num2[3:0] + 3;
                if(num3[3:0] > 4'd4) 
                    num3[3:0] = num3[3:0] + 3;
                if(num4[3:0] > 4'd4) 
                    num4[3:0] = num4[3:0] + 3;
                if(num5[3:0] > 4'd4) 
                    num5[3:0] = num5[3:0] + 3;
                if(num6[3:0] > 4'd4) 
                    num6[3:0] = num6[3:0] + 3;
                if(num7[3:0] > 4'd4) 
                    num7[3:0] = num7[3:0] + 3;
                if(num8[3:0] > 4'd4) 
                    num8[3:0] = num8[3:0] + 3;
                if(num9[3:0] > 4'd4) 
                    num9[3:0] = num9[3:0] + 3;
                if(num10[3:0] > 4'd4) 
                    num10[3:0] = num10[3:0] + 3;

                //shift left one
                num10 = {num10[2:0],num9[3]};
                num9 = {num9[2:0],num8[3]};
                num8 = {num8[2:0],num7[3]};
                num7 = {num7[2:0],num6[3]};
                num6 = {num6[2:0],num5[3]};
                num5 = {num5[2:0],num4[3]};
                num4 = {num4[2:0],num3[3]};
                num3 = {num3[2:0],num2[3]};
                num2 = {num2[2:0],num1[3]};
                num1 = {num1[2:0],num[31-i]};
            end
        end             
endmodule