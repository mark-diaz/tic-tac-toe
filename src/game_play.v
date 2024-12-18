module game_play(
    input clk,
    input reset,
    input [17:0] tiles,
    output reg game_over,
    output reg [8:0] color
    );

    parameter GAME_CONTINUE = 0;
    parameter GAME_WON = 1;
    
    reg prev_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= GAME_CONTINUE;
        end
        else
            prev_state <= next_state;
    end

    // Horizontal win conditions
    wire horiz1_win = (tiles[1:0] == tiles[3:2] && tiles[3:2] == tiles[5:4] && tiles[1:0] != 0);  // Row 1: Tiles 0, 1, 2
    wire horiz2_win = (tiles[7:6] == tiles[9:8] && tiles[9:8] == tiles[11:10] && tiles[7:6] != 0); // Row 2: Tiles 3, 4, 5
    wire horiz3_win = (tiles[13:12] == tiles[15:14] && tiles[15:14] == tiles[17:16] && tiles[13:12] != 0); // Row 3: Tiles 6, 7, 8

    // Vertical win conditions 
    wire vert1_win = (tiles[1:0] == tiles[7:6] && tiles[7:6] == tiles[13:12] && tiles[1:0] != 0); // Column 1: Tiles 0, 3, 6
    wire vert2_win = (tiles[3:2] == tiles[9:8] && tiles[9:8] == tiles[15:14] && tiles[3:2] != 0); // Column 2: Tiles 1, 4, 7
    wire vert3_win = (tiles[5:4] == tiles[11:10] && tiles[11:10] == tiles[17:16] && tiles[5:4] != 0); // Column 3: Tiles 2, 5, 8

    // Diagonal win conditions
    wire diag1_win = (tiles[1:0] == tiles[9:8] && tiles[9:8] == tiles[17:16] && tiles[1:0] != 0); // Diagonal 1: Tiles 0, 4, 8
    wire diag2_win = (tiles[5:4] == tiles[9:8] && tiles[9:8] == tiles[13:12] && tiles[5:4] != 0); // Diagonal 2: Tiles 2, 4, 6


    always @(*) begin
    
    color = 9'b000000000;  // No win

        case (prev_state)
            
            GAME_CONTINUE: 
                begin
                    
                    if (horiz1_win) begin
                        color = 9'b000000111;  // row 1 win
                        next_state = GAME_WON; 
                    end
                    else if (horiz2_win) begin
                        color = 9'b000111000;  // row 2 win
                        next_state = GAME_WON; 
                    end
                    else if (horiz3_win) begin
                        color = 9'b111000000;  // row 3 win
                        next_state = GAME_WON; 
                    end
                    else if (vert1_win) begin
                        color = 9'b001001001;  // column 1 win
                        next_state = GAME_WON; 
                    end
                    else if (vert2_win) begin
                        color = 9'b010010010;  // column 2 win
                        next_state = GAME_WON; 
                    end
                    else if (vert3_win) begin
                        color = 9'b100100100;  // column 3 win
                        next_state = GAME_WON; 
                    end
                    else if (diag1_win) begin
                        color = 9'b100010001;  // diagonal 1 win
                        next_state = GAME_WON; 
                    end
                    else if (diag2_win) begin
                        color = 9'b001010100;  // diagonal 2 win
                        next_state = GAME_WON; 
                    end
                    else begin
                        color = 9'b000000000;  // No win
                        next_state = GAME_CONTINUE; 
                    end

                    game_over = 1'b0;
                end

            GAME_WON :
                begin
                    game_over = 1'b1;
                    next_state = GAME_WON;
                end

            default: 
                begin
                    color = 0;
                    game_over = 1'b0;
                    next_state = GAME_CONTINUE;
                end
        endcase
    end
endmodule
