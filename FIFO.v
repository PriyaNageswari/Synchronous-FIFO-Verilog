module FIFO(input clk,rst,wrt,rd, input [7:0]din, 
output full,emt,output reg [7:0]dout);
    reg [7:0]fifo[0:7];
    reg [2:0]wrt_ptr, wrt_ptr_nxt, wrt_ptr_inc;
    reg [2:0]rd_ptr, rd_ptr_nxt, rd_ptr_inc;
    reg fifo_full_reg, fifo_emt_reg, full_nxt,emt_nxt;
    
    //writing into memory
    wire wrt_en,rd_en;
    assign wrt_en = (wrt & ~fifo_full_reg);
    assign rd_en = (rd & ~fifo_emt_reg);
    always @ (posedge clk) begin
        if(wrt_en)
            fifo[wrt_ptr] <= din;
        if(rd_en)
            dout <= fifo[rd_ptr];
    end
    
    //reading from memory
    assign full = fifo_full_reg;
    assign emt = fifo_emt_reg;
    
    //calculation part or nxt process
    always @ * begin
        // increment process
        wrt_ptr_inc = wrt_ptr + 1;
        rd_ptr_inc = rd_ptr + 1;
        
        // holding state
        wrt_ptr_nxt = wrt_ptr;  //wrt_ptr is where to store  [0 -> 7]
        rd_ptr_nxt = rd_ptr;  // rd_ptr is from where to take  [7 -> 0]
        full_nxt = fifo_full_reg;  
        emt_nxt = fifo_emt_reg;   
        
        case({wrt,rd})
            2'b00 : begin end
            2'b10 : begin
                        if(~fifo_full_reg) begin
                            wrt_ptr_nxt = wrt_ptr_inc;
                            emt_nxt = 0;
                            if(wrt_ptr_inc == rd_ptr)  //whne inc 8 it is 4'b1000 but we have three bit
                                full_nxt = 1;        // so it take last three bits which is 000
                        end
                    end
             2'b01 : begin
                        if(~fifo_emt_reg) begin
                            rd_ptr_nxt = rd_ptr_inc;
                            full_nxt = 0;
                            if(rd_ptr_inc == wrt_ptr) 
                                emt_nxt = 1;
                        end
                    end
             2'b11 : begin
                        if(~fifo_full_reg && ~fifo_emt_reg) begin
                            wrt_ptr_nxt = wrt_ptr_inc;
                            rd_ptr_nxt  = rd_ptr_inc;
                        end
                     end
        endcase 
    end
    always @(posedge clk or posedge rst) begin    // posedge rst
        if(rst) begin
            wrt_ptr <= 0;
            rd_ptr <= 0;
            fifo_full_reg <= 0;
            fifo_emt_reg <= 1;
        end
        else begin
            wrt_ptr <= wrt_ptr_nxt;
            rd_ptr <= rd_ptr_nxt;
            fifo_full_reg <= full_nxt;
            fifo_emt_reg <= emt_nxt;
        end
    end
endmodule
