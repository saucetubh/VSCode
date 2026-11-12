/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


//This module implements the FSM part of the predictor. If the address of a branch does not match the 
//branch address of the value stored in the table, the state is initialised with 3, and the old branch
//address value is replaced.
module branchFSM(input clk, input reset, input enable, input actual_outcome, input [4:0] branch_address, output reg [1:0] state);
    reg [1:0] new_state;
    reg [4:0] stored_BA;
    reg [4:0] new_stored_BA;
    
    //WRITE YOUR CODE HERE
    // Sequential Logic: Registers for state and stored branch address
    always @(posedge clk)
    begin
        if(reset)
        begin
            // On reset, go to a known initial state (e.g., 3) and clear stored address
            state <= 2'd3; 
            stored_BA <= 5'd0;
        end
        else if(enable)
        begin
            // On enable, update state and stored address based on combinational logic
            state <= new_state;
            stored_BA <= new_stored_BA;
        end
        // If not reset and not enabled, registers hold their values
    end

    // Combinational Logic: Determines the next state and next stored address
    always @(*)
    begin
        // Default assignments (assume no change unless logic dictates otherwise)
        new_state = state; 
        new_stored_BA = stored_BA;

        // Check if the current branch address is different from the stored one
        if(stored_BA != branch_address )
        begin
            // If different, reset the FSM state (e.g., to 3) and store the new address
            new_state = 2'b11; // Or 2'd3, matching the reset state
            new_stored_BA = branch_address;
        end
        // If the branch address is the same as the stored one, update state based on outcome
        else 
        begin
            // Use if-else if instead of case for structural difference
            if (state == 2'd3) begin // State 3 logic
                if(actual_outcome == 1'd1)
                    new_state = 2'd3; // Stay in state 3 if taken
                else
                    new_state = 2'd2; // Move to state 2 if not taken
            end 
            else if (state == 2'd0) begin // State 0 logic
                if(actual_outcome == 1'd1)
                    new_state = 2'd1; // Move to state 1 if taken
                else
                    new_state = 2'd0; // Stay in state 0 if not taken
            end
            else begin // Default logic for states 1 and 2
                if(actual_outcome == 1'd1)
                    new_state = state + 2'd1; // Increment state towards 3 if taken
                else
                    new_state = state - 2'd1; // Decrement state towards 0 if not taken
            end
        end
        
    end
endmodule

//This corresponds to a single entry in the table: the branch address, the target address and the state.
module branchTB_reg (input clk, input reset, input enable, input [31:0] in_branch_addr, input [31:0] in_target_addr, input actual_outcome,  
                    output [31:0] out_branch_addr, output [31:0] out_target_addr, output [1:0] out_state);
    
    register32bit entry_BA (clk, reset, enable, in_branch_addr, out_branch_addr);
    register32bit entry_TA (clk, reset, enable, in_target_addr, out_target_addr);
    branchFSM entry0_FSM (clk, reset, enable, actual_outcome, in_branch_addr[6:2], out_state);

endmodule 

//This module implements the branch predictor. This predictor has only one entry.
module branchTB(input clk, input reset, input [31:0] branch_addr, input [31:0] target_addr, input actual_outcome,
                input enable, input [31:0] search_entry, output predict, output match,  output [31:0] ta0);

    wire [31:0] ba0;
    wire [1:0] state0;
    
    branchTB_reg entry0 (clk, reset, enable, branch_addr, target_addr, actual_outcome, ba0, ta0, state0);
    buf(predict, state0[1]);
    comparator branchTB_match (search_entry, ba0, match);
    
endmodule