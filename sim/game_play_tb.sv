module game_play_tb ();
    
    reg clk = 1'b0;
    reg reset = 1'b1;
    reg [17:0] tiles;

    wire game_over;
    reg [8:0] color;

    game_play uut(
        .clk(clk),
        .reset(reset),
        .tiles(tiles),
        .game_over(game_over),
        .color(color)
    );

    always #10 clk = ~clk;
    initial begin
        tiles = 17'd0;
        # 10 reset = 1'b0;
        
        #20;
        tiles = 12'h3F;

        #20;
        tiles = 12'hFC0;
        
        #20;

        $finish();
    end
endmodule