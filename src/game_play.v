module game_play(
    input clk,
    input reset,
    input undo_sig,
    input [17:0] tiles,
    output reg game_over,
    output reg [8:0] color
    );

    parameter GAME_CONTINUE = 0;
    parameter GAME_OVER = 1;
    
    reg prev_state;
    reg next_state;

    reg [17:0] tiles_stack [0:15]; 
    reg [0:0] prev_state_stack [0:15]; 
    reg [3:0] stack_ptr; 
    
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= GAME_CONTINUE;
            stack_ptr <= 0;
        end else if (undo_sig && stack_ptr > 0) begin
            stack_ptr <= stack_ptr - 1;
            prev_state <= prev_state_stack[stack_ptr - 1];
        end else begin
            prev_state <= next_state;
        end
    end

    // Horizontal win conditions
    wire horiz1_win = (tiles[1:0] == tiles[3:2] && tiles[3:2] == tiles[5:4] && tiles[1:0] != 0);  // Row 1: Tiles 1, 2, 3
    wire horiz2_win = (tiles[7:6] == tiles[9:8] && tiles[9:8] == tiles[11:10] && tiles[7:6] != 0); // Row 2: Tiles 4, 5, 6
    wire horiz3_win = (tiles[13:12] == tiles[15:14] && tiles[15:14] == tiles[17:16] && tiles[13:12] != 0); // Row 3: Tiles 7, 8, 9

    // Vertical win conditions 
    wire vert1_win = (tiles[1:0] == tiles[7:6] && tiles[7:6] == tiles[13:12] && tiles[1:0] != 0); // Column 1: Tiles 1, 4, 7
    wire vert2_win = (tiles[3:2] == tiles[9:8] && tiles[9:8] == tiles[15:14] && tiles[3:2] != 0); // Column 2: Tiles 2, 5, 8
    wire vert3_win = (tiles[5:4] == tiles[11:10] && tiles[11:10] == tiles[17:16] && tiles[5:4] != 0); // Column 3: Tiles 3, 6, 9

    // Diagonal win conditions
    wire diag1_win = (tiles[1:0] == tiles[9:8] && tiles[9:8] == tiles[17:16] && tiles[1:0] != 0); // Diagonal 1: Tiles 1, 5, 9
    wire diag2_win = (tiles[5:4] == tiles[9:8] && tiles[9:8] == tiles[13:12] && tiles[5:4] != 0); // Diagonal 2: Tiles 3, 5, 7


   always @(posedge clk) begin
        if (reset) begin
            stack_ptr <= 0;
        end else if (!undo_sig && next_state == GAME_CONTINUE) begin
            tiles_stack[stack_ptr] <= tiles;
            prev_state_stack[stack_ptr] <= prev_state;
            stack_ptr <= stack_ptr + 1;
        end
    end


    always @(*) begin
        case (prev_state)
            GAME_CONTINUE: 
                begin
                    if (horiz1_win) begin
                        color = 9'b000000111;  // row 1 win
                        next_state = GAME_OVER; 
                    end
                    else if (horiz2_win) begin
                        color = 9'b000111000;  // row 2 win
                        next_state = GAME_OVER; 
                    end
                    else if (horiz3_win) begin
                        color = 9'b111000000;  // row 3 win
                        next_state = GAME_OVER; 
                    end
                    else if (vert1_win) begin
                        color = 9'b001001001;  // column 1 win
                        next_state = GAME_OVER; 
                    end
                    else if (vert2_win) begin
                        color = 9'b010010010;  // column 2 win
                        next_state = GAME_OVER; 
                    end
                    else if (vert3_win) begin
                        color = 9'b100100100;  // column 3 win
                        next_state = GAME_OVER; 
                    end
                    else if (diag1_win) begin
                        color = 9'b100010001;  // diagonal 1 win
                        next_state = GAME_OVER; 
                    end
                    else if (diag2_win) begin
                        color = 9'b001010100;  // diagonal 2 win
                        next_state = GAME_OVER; 
                    end
                    else begin
                        color = 9'b000000000;  // No win
                        next_state = GAME_OVER; 
                    end

                end

            GAME_OVER :
                begin
                    game_over = 1'b1;
                    next_state = game_over;
                end

            default: 
                begin
                    color = 0;
                    game_over = 0;
                    next_state = GAME_CONTINUE;
                end
        endcase
    end
endmodule




