module game_top(
    input clk,
    input reset,
    input undo_sig,
    input [8:0] input_switches,
    output hsync,
    output vsync,
    output [11:0] rgb
    );
    
    wire [8:0] color;
    reg [8:0] player_move;
    reg [17:0] tiles;
    reg [8:0] previous_input;
    reg [8:0] current_input;
    
    wire game_over;
    reg current_turn;

    // Undo stacks
    reg [17:0] tiles_stack [0:15]; // Stack to store previous board states
    reg current_turn_stack [0:15]; // Stack to store turn states


    // prioritize the most significant tile selected

    // tile mapping:
    always @(*) begin
        if (!game_over) begin
            if (input_switches[6] && !tiles[16])
                player_move = 9'b100000000;
            else if (input_switches[7] && !tiles[14])
                player_move = 9'b010000000;
            else if (input_switches[8] && !tiles[12])
                player_move = 9'b001000000;

            else if (input_switches[3] && !tiles[10])
                player_move = 9'b000100000;
            else if (input_switches[4] && !tiles[8])
                player_move = 9'b000010000;
            else if (input_switches[5] && !tiles[6])
                player_move = 9'b000001000;

            else if (input_switches[0] && !tiles[4])
                player_move = 9'b000000100;
            else if (input_switches[1] && !tiles[2])
                player_move = 9'b000000010;
            else if (input_switches[2] && !tiles[0])
                player_move = 9'b000000001;                
        end
    end
    
    always @(posedge clk) begin
        if (previous_input != current_input && current_input != 0)
            current_turn <= ~current_turn;
        previous_input <= current_input;
        current_input <= input_switches;
    end

    game_play game_logic (
        .clk(clk),
        .reset(reset),
        .undo_sig(undo_sig),  // Pass undo signal
        .tiles(tiles),
        .game_over(game_over),
        .color(color)
    );
    
    tile_display display (
        .clk(clk),
        .tiles(tiles),
        .color(color),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

//    // generate all nine tiles
//    genvar i;
//    generate
//        for (i = 0; i < 9; i = i + 1) begin
//            tile tile_inst (
//                .clk(clk),
//                .sel(player_move[i]),
//                .turn(current_turn),
//                .reset(reset),
//                .state(tiles[2*i+1:2*i])
//            );
//        end
//    endgenerate// Generate all nine tiles
    
    
    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin
            wire [1:0] tile_state;
            assign tile_state = tiles[2*i +: 2];
        
            tile tile_inst (
                .clk(clk),
                .sel(player_move[i]),
                .turn(current_turn),
                .reset(reset),
                .state(tile_state)  // Correct slicing of 2 bits for each tile
            );
        end
    endgenerate

    
endmodule
