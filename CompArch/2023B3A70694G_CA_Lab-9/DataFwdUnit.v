/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module forwardingUnit(input [4:0] rs_id, input [4:0] rt_id, input [4:0] rs_ex, input [4:0] rt_ex, input [4:0] rd_mem, 
                        input [4:0] rd_wb, input regwrite_mem, input regwrite_wb, 
                        output reg [1:0] forward_a, output reg [1:0] forward_b, output reg forward_c, output reg forward_ad, output reg forward_bd);
    
    //WRITE YOUR CODE HERE
    // Use an implicit sensitivity list for combinational logic
    always @(*) begin
        
        // --- Logic for Forward A (ALU Input 1) ---
        // MEM-to-EX hazard has the highest priority
        if (regwrite_mem && (rd_mem != 0) && (rs_ex == rd_mem)) begin
            forward_a = 2'b10; // Forward from MEM stage
        end
        // WB-to-EX hazard has the second priority
        else if (regwrite_wb && (rd_wb != 0) && (rs_ex == rd_wb)) begin
            forward_a = 2'b01; // Forward from WB stage
        end
        // Default case: No forwarding
        else begin
            forward_a = 2'b00;
        end

        // --- Logic for Forward B (ALU Input 2) ---
        // MEM-to-EX hazard has the highest priority
        if (regwrite_mem && (rd_mem != 0) && (rt_ex == rd_mem)) begin
            forward_b = 2'b10; // Forward from MEM stage
        end
        // WB-to-EX hazard has the second priority
        else if (regwrite_wb && (rd_wb != 0) && (rt_ex == rd_wb)) begin
            forward_b = 2'b01; // Forward from WB stage
        end
        // Default case: No forwarding
        else begin
            forward_b = 2'b00;
        end
        
        // --- Logic for other hazard signals (e.g., for ID stage) ---
        
        // Hazard check for rs_id
        if (regwrite_mem && (rs_id == rd_mem) && (rs_id != 0)) begin
            forward_ad = 1'b1;
        end 
        else begin
            forward_ad = 1'b0;
        end
        
        // Hazard check for rt_id
        if (regwrite_mem && (rt_id == rd_mem) && (rt_id != 0)) begin
            forward_bd = 1'b1;
        end 
        else begin
            forward_bd = 1'b0;
        end

        // Logic for forward_c
        if (!regwrite_mem && regwrite_wb && (rd_wb == rd_mem)) begin
            forward_c = 1'b1;
        end 
        else begin
            forward_c = 1'b0;
        end
    end
    

endmodule

