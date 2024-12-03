module game_top(
    input clk,
    input reset,
    input [8:0] input_switches,
    output hsync,
    output vsync,
    output [11:0] rgb
    );
    
    wire [8:0] color;
    reg [8:0] player_move;
    wire [17:0] tiles;
    // wire [1:0] tile0_state, tile1_state, tile2_state, tile3_state, tile4_state, tile5_state, tile6_state, tile7_state, tile8_state;
    
    reg [8:0] previous_input;
    reg [8:0] current_input;
    
    
    wire game_over;
    reg current_turn;
    
    wire valid_move;
    assign valid_move = (player_move != 9'b000000000);
    
    // stack to track previous moves


    // prioritize the most significant tile selected

    // tile mapping:
    always @(*) begin
        player_move = 9'b000000000;    
    
        if (!game_over) begin
            if (input_switches[6] && tiles[16]) // Check tile 8 state
                player_move = 9'b100000000;
            else if (input_switches[7] && tiles[14]) // Check tile 7 state
                player_move = 9'b010000000;
            else if (input_switches[8] && tiles[12]) // Check tile 6 state
                player_move = 9'b001000000;
            else if (input_switches[3] && tiles[10]) // Check tile 5 state
                player_move = 9'b000100000;
            else if (input_switches[4] && tiles[8]) // Check tile 4 state
                player_move = 9'b000010000;
            else if (input_switches[5] && tiles[6]) // Check tile 3 state
                player_move = 9'b000001000;
            else if (input_switches[0] && tiles[4]) // Check tile 2 state
                player_move = 9'b000000100;
            else if (input_switches[1] && tiles[2]) // Check tile 1 state
                player_move = 9'b000000010;
            else if (input_switches[2] && tiles[0]) // Check tile 0 state
                player_move = 9'b000000001;
            else 
                player_move = 9'b000000000;                
        end
    end
        
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_turn <= 1'b0;          // X starts first
            previous_input <= 9'b0;
            current_input <= 9'b0;
            
        end 
        else begin
        
            current_input <= input_switches;  
            previous_input <= current_input;  

            if (current_input != previous_input && valid_move) begin
                current_turn <= ~current_turn;  // Switch turns
            end
                        
       end
    end

    game_play game_logic (
        .clk(clk),
        .reset(reset),
        .tiles(tiles),
        .game_over(game_over),
        .color(color)
    );
    
    tile_display display (
        .clk(clk),
        .reset(reset),
        .tiles(tiles),
        .color(color),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

//    tile tile0_inst (
//        .clk(clk),
//        .sel(player_move[0]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile0_state) 
//    );

//    tile tile1_inst (
//        .clk(clk),
//        .sel(player_move[1]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile1_state)  
//    );
    
//    tile tile2_inst (
//        .clk(clk),
//        .sel(player_move[2]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile2_state)  
//    );
    
//    tile tile3_inst (
//        .clk(clk),
//        .sel(player_move[3]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile3_state)  
//    );
    
//    tile tile4_inst (
//        .clk(clk),
//        .sel(player_move[4]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile4_state)  
//    );
    
//    tile tile5_inst (
//        .clk(clk),
//        .sel(player_move[5]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile5_state)  
//    );
    
//    tile tile6_inst (
//        .clk(clk),
//        .sel(player_move[6]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile6_state)  
//    );
    
//    tile tile7_inst (
//        .clk(clk),
//        .sel(player_move[7]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile7_state)  
//    );
    
//    tile tile8_inst (
//        .clk(clk),
//        .sel(player_move[8]),
//        .turn(current_turn),
//        .reset(reset),
//        .tile_state(tile8_state)  
//    );
    
    generate
    genvar n;
    for (n = 0; n < 9; n = n + 1) begin : tile_inst
        tile tile_instance (
            .clk(clk),
            .sel(player_move[n]),
            .turn(current_turn),
            .reset(reset),
            .tile_state(tiles[2*n + 1:2*n]) // Access tiles[2*n:n] directly
        );
    end
    endgenerate
    
//    always @(posedge clk or posedge reset) begin 
//        if (reset)
//            tiles <= 18'd0;
//        else begin
//            tiles[0] <= tile0_state;
//            tiles[1] <= tile1_state;
//            tiles[2] <= tile2_state;
//            tiles[3] <= tile3_state;
//            tiles[4] <= tile4_state;
//            tiles[5] <= tile5_state;
//            tiles[6] <= tile6_state;
//            tiles[7] <= tile7_state;
//            tiles[8] <= tile8_state;
//        end
//    end
    

    
endmodule
