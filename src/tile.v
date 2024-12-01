module tile(
    input clk,
    input reset,
    input sel,
    input turn,
    output reg [1:0] state
    );
    
    parameter EMPTY_STATE = 0;
    parameter X_STATE = 1;
    parameter O_STATE = 2;
    
    reg [1:0] next_state;
    reg [1:0] prev_state;

    always @(posedge clk) begin
        if (reset)
            prev_state <= EMPTY_STATE;
        else 
            prev_state <= next_state;
    end
    
    always @ (*) begin
  
        case (prev_state)
            EMPTY_STATE :
            begin
                state = 2'b00;
                
                if (sel & ~turn) begin
                    next_state = X_STATE;
                end
                else if (sel & turn) begin
                    next_state = O_STATE;
                end
                else begin
                    next_state = prev_state;
                end
            end
            
            X_STATE : 
            begin
                state = 2'b01;
                next_state = prev_state;
            end
            
            O_STATE :
            begin
                state = 2'b10;
                next_state = prev_state;
            end
            
            default :
            begin
                state = 2'b00;
                prev_state = EMPTY_STATE;
                next_state = EMPTY_STATE;
            end
        endcase
    end

endmodule
