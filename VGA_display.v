module clk_div(clk,rst,div_clk);
    input clk,rst;
    output div_clk;
    reg div_clk;

    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            div_clk <= 1'b0;
        end
        else
        begin
            div_clk = ~div_clk;
        end
    end
endmodule

module VGA_control(clk, rst, but_R, but_G, but_B, out_R, out_G, out_B,Hsync,Vsync);
    input clk, rst, but_R, but_G, but_B;
    output reg[3:0] out_R, out_G, out_B;
    output reg Hsync, Vsync;
    reg [9:0]counter_x, counter_y;
    reg [3:0]tmp_r,tmp_g,tmp_b;
    // counter and sync generation
    always @(posedge clk) // horizontal counter
    begin
        if(counter_x < 10'd799)
        begin
            counter_x <= counter_x + 10'd1; // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels counter_x = 0~799
        end
        else
        begin
            counter_x <= 10'd0;
        end
    end // always

    always @ (posedge clk)  // vertical counter
    begin 
        if(counter_x == 10'd799)  // only counts up 1 count after horizontal finishes 800 counts
        begin
            if(counter_y < 10'd525) // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
            begin 
                counter_y <= counter_y + 10'd1;
            end
            else 
            begin
                counter_y <= 10'd0;
            end							 
        end  
    end  
    // end counter and sync generation  

    always @(posedge clk or negedge rst) 
    begin
        if(!rst)
        begin
            out_R <= 4'd0;
            out_G <= 4'd0;
            out_B <= 4'd0;
        end
        else 
        begin
            Hsync <= (counter_x >= 10'd0 && counter_x < 10'd96) ? 1'b0:1'b1;  // hsync low for 96 counts                                                 
            Vsync <= (counter_y >= 10'd0 && counter_y < 10'd2) ? 1'b0:1'b1;   // vsync low for 2 counts
            if(counter_x>=10'd96 && counter_x<=10'd144)
            begin               out_R <= 4'd0;
                out_G <= 4'd0;
                out_B <= 4'd0;
            end
            else
            begin
                out_R <= tmp_r;
                out_G <= tmp_g;
                out_B <= tmp_b;
            end
        end
	end
        
    
    always @(posedge but_R ) begin
        tmp_r <= tmp_r + 4'd1;
    end      
    always @(posedge but_G ) begin
        tmp_g <= tmp_g + 4'd1;
    end      
    always @(posedge but_B ) begin
        tmp_b <= tmp_b + 4'd1;
	end

    // assign Hsync = (counter_x >= 10'd0 && counter_x < 10'd96) ? 1'b0:1'b1;  // hsync low for 96 counts                                                 
    // assign Vsync = (counter_y >= 10'd0 && counter_y < 10'd2) ? 1'b0:1'b1;   // vsync low for 2 counts
endmodule


module VGA_display(clk, rst, out_R, out_G, out_B,Hsync,Vsync);
    input clk, rst;
    output reg[3:0] out_R, out_G, out_B;
    output reg Hsync, Vsync;
    reg [9:0]counter_x, counter_y;
    reg [3:0]tmp_r,tmp_g,tmp_b;
    // counter and sync generation
    always @(posedge clk) // horizontal counter
    begin
        if(counter_x < 10'd799)
        begin
            counter_x <= counter_x + 10'd1; // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels counter_x = 0~799
        end
        else
        begin
            counter_x <= 10'd0;
        end
    end // always

    always @ (posedge clk)  // vertical counter
    begin 
        if(counter_x == 10'd799)  // only counts up 1 count after horizontal finishes 800 counts
        begin
            if(counter_y < 10'd525) // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
            begin 
                counter_y <= counter_y + 10'd1;
            end
            else 
            begin
                counter_y <= 10'd0;
            end							 
        end  
    end  
    // end counter and sync generation  
    //signal control
    always @(posedge clk or negedge rst) 
    begin
        if(!rst)
        begin
            out_R <= 4'd0;
            out_G <= 4'd0;
            out_B <= 4'd0;
        end
        else 
        begin
            Hsync <= (counter_x >= 10'd0 && counter_x < 10'd96) ? 1'b0:1'b1;  // hsync low for 96 counts                                                 
            Vsync <= (counter_y >= 10'd0 && counter_y < 10'd2) ? 1'b0:1'b1;   // vsync low for 2 counts
            if(counter_x>=10'd96 && counter_x<=10'd144)
            begin               
                out_R <= 4'd0;
                out_G <= 4'd0;
                out_B <= 4'd0;
            end
            else
            begin
                out_R <= tmp_r;
                out_G <= tmp_g;
                out_B <= tmp_b;
            end
        end
	end

    // pattern generate
        always @ (posedge clk)
        begin
            ////////////////////////////////////////////////////////////////////////////////////// SECTION 1
            if (counter_y < 50)//space to top
                begin              
                    tmp_r <= 4'h0;    // black
                    tmp_b <= 4'h0;
                    tmp_g <= 4'h0;
                end  
            ////////////////////////////////////////////////////////////////////////////////////// END SECTION 1
            
            ////////////////////////////////////////////////////////////////////////////////////// SECTION 2
            else if (counter_y >= 50 && counter_y < 55)
                begin 
                    if (counter_x >= 50 && counter_x < 590)
                        begin 
                            tmp_r <= 4'hF;    // white
                            tmp_b <= 4'hF;
                            tmp_g <= 4'hF;
                        end  
                    else
                        begin 
                            tmp_r <= 4'h0;    // black
                            tmp_b <= 4'h0;
                            tmp_g <= 4'h0;
                        end  
                    end 
            ////////////////////////////////////////////////////////////////////////////////////// END SECTION 2
            
            ////////////////////////////////////////////////////////////////////////////////////// SECTION 3
            else if (counter_y >= 55 && counter_y < 105)
                begin   
                    if (counter_x >= 50 && counter_x < 55)
                        begin 
                            tmp_r <= 4'hF;    // white
                            tmp_b <= 4'hF;
                            tmp_g <= 4'hF;
                        end  // else if (counter_x >= 324 && counter_x < 371)
                    else if (counter_x >= 585 && counter_x < 590)
                        begin 
                            tmp_r <= 4'hF;    // white
                            tmp_b <= 4'hF;
                            tmp_g <= 4'hF;
                        end  // else if (counter_x >= 383 && counter_x < 545)
                    else 
                        begin
                            tmp_r <= 4'h0;    // black
                            tmp_b <= 4'h0;
                            tmp_g <= 4'h0;
                        end  // else if (counter_x >= 604)
                end  // else if (counter_y >= 205 && counter_y < 217)
            ////////////////////////////////////////////////////////////////////////////////////// END SECTION 3
            
            ////////////////////////////////////////////////////////////////////////////////////// SECTION 4
            else if (counter_y >= 105 && counter_y < 110)
                begin 
                    if (counter_x >= 50 && counter_x < 590)
                        begin 
                            tmp_r <= 4'hF;    // white
                            tmp_b <= 4'hF;
                            tmp_g <= 4'hF;
                        end  
                    else
                        begin 
                            tmp_r <= 4'h0;    // black
                            tmp_b <= 4'h0;
                            tmp_g <= 4'h0;
                        end  
                    end 
            ////////////////////////////////////////////////////////////////////////////////////// END SECTION 4
            
            ////////////////////////////////////////////////////////////////////////////////////// SECTION 5
        //     else if (counter_y >= 305 && counter_y < 310)
        //         begin
        //             if (counter_x < 324)
        //                 begin 
        //                     tmp_r <= 4'hF;    // white
        //                     tmp_b <= 4'hF;
        //                     tmp_g <= 4'hF;
        //                 end  // if (counter_x < 324)
        //             else if (counter_x >= 324 && counter_x < 371)
        //                 begin 
        //                     tmp_r <= 4'hF;    // yellow
        //                     tmp_b <= 4'h0;
        //                     tmp_g <= 4'hF;
        //                 end  // else if (counter_x >= 324 && counter_x < 371)
        //             else if (counter_x >= 371 && counter_x < 557)
        //                 begin 
        //                     tmp_r <= 4'h0;    // black
        //                     tmp_b <= 4'h0;
        //                     tmp_g <= 4'h0;
        //                 end  // else if (counter_x >= 371 && counter_x < 557)
        //             else if (counter_x >= 557 && counter_x < 604)
        //                 begin 
        //                     tmp_r <= 4'hF;    // yellow
        //                     tmp_b <= 4'h0;
        //                     tmp_g <= 4'hF;
        //                 end  // else if (counter_x >= 557 && counter_x < 604)
        //             else if (counter_x >= 604)
        //                 begin 
        //                     tmp_r <= 4'hF;    // white
        //                     tmp_b <= 4'hF;
        //                     tmp_g <= 4'hF;
        //                 end  // else if (counter_x >= 604)	
        //         end  // else if (counter_y >= 217 && counter_y < 305)
        //     ////////////////////////////////////////////////////////////////////////////////////// END SECTION 5
            
        //     ////////////////////////////////////////////////////////////////////////////////////// SECTION 6
        //     else if (counter_y >= 305 && counter_y < 414)
        //         begin
        //             if (counter_x < 324)
        //                 begin 
        //                     tmp_r <= 4'hF;    // white
        //                     tmp_b <= 4'hF;
        //                     tmp_g <= 4'hF;
        //                 end  // if (counter_x < 324)
        //             else if (counter_x >= 324 && counter_x < 604)
        //                 begin 
        //                     tmp_r <= 4'hF;    // yellow
        //                     tmp_b <= 4'h0;
        //                     tmp_g <= 4'hF;
        //                 end  // else if (counter_x >= 324 && counter_x < 604)
        //             else if (counter_x >= 604)
        //                 begin 
        //                     tmp_r <= 4'hF;    // white
        //                     tmp_b <= 4'hF;
        //                     tmp_g <= 4'hF;
        //                 end  // else if (counter_x >= 604)	
        //         end  // else if (counter_y >= 305 && counter_y < 414)
        //     ////////////////////////////////////////////////////////////////////////////////////// END SECTION 6
            
        //     ////////////////////////////////////////////////////////////////////////////////////// SECTION 7
        //     else if (counter_y <= 414)
        //         begin              
        //             tmp_r <= 4'hF;    // white
        //             tmp_b <= 4'hF;
        //             tmp_g <= 4'hF;
        //         end  // if (counter_y >= 414)
		// 	////////////////////////////////////////////////////////////////////////////////////// END SECTION 7
		// end  // always
						
	// end pattern generate
        
    
    

    // assign Hsync = (counter_x >= 10'd0 && counter_x < 10'd96) ? 1'b0:1'b1;  // hsync low for 96 counts                                                 
    // assign Vsync = (counter_y >= 10'd0 && counter_y < 10'd2) ? 1'b0:1'b1;   // vsync low for 2 counts
endmodule

module VGA_output(clk,rst,but_R,but_G,but_B,out_R,out_G,out_B,Hsync,Vsync);
    input clk,rst,but_R,but_G,but_B;
    output [3:0] out_R,out_G,out_B;
    output Hsync, Vsync;
    wire div_clk;
    clk_div u_clk_div(.clk(clk),.rst(rst),.div_clk(div_clk));
    VGA_display u_VGA_display(.clk(div_clk), .rst(rst), .out_R(out_R), .out_G(out_G), .out_B(out_B),.Hsync(Hsync),.Vsync(Vsync));

endmodule

