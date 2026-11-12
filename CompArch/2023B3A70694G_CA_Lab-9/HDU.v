/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module hazardDetectionUnit(input memtoreg_mem, input branch_id, input regwrite_ex, input memtoreg_ex, input [4:0] rd_ex, 
                            input [4:0] rd_mem, input [4:0] rs_id, input [4:0] rt_id, output reg stall);                //Changed signature
    
    //WRITE YOUR CODE HERE
    always @(*)
    begin
        // Default to no stall
        stall = 1'b0; 

        // Check for Load-Use hazard (load in EX stage, use in ID stage)
        if (memtoreg_ex && (rd_ex == rs_id || rd_ex == rt_id))
        begin
            stall = 1'b1;
        end
        // Check for Branch hazard (branch in ID stage, dependency on instruction in EX stage)
        else if (branch_id && regwrite_ex && (rd_ex == rs_id || rd_ex == rt_id))
        begin
            stall = 1'b1;
        end
        // Check for Branch hazard (branch in ID stage, dependency on instruction in MEM stage)
        else if (branch_id && memtoreg_mem && (rd_mem == rs_id || rd_mem == rt_id))
        begin
            stall = 1'b1;
        end
        // Check for the other load-related condition from the original logic
        else if (memtoreg_ex && (rd_mem == rs_id || rd_mem == rt_id))
        begin
            stall = 1'b1;
        end
        // Check for the other pipeline-specific condition from the original logic
        else if (rd_mem == rd_ex && memtoreg_mem && !regwrite_ex && !memtoreg_ex)
        begin
            stall = 1'b1;
        end
    end


endmodule

