module game_top_tb;

    reg clk;
    reg reset;
    reg [8:0] input_switches;
    reg [17:0] tiles;
    wire hsync;
    wire vsync;
    wire [11:0] rgb;

    // Instantiate the DUT
    game_top dut (
        .clk(clk),
        .reset(reset),
        .input_switches(input_switches),
//        .tiles(tiles),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        input_switches = 9'b0;
        tiles = 17'd0;
        #20;

        // Release reset
        reset = 0;
        #10;

        // Player selects tile 0
        input_switches = 9'b000000001;
        tiles = 17'b0000_0000_0000_0000_11;
        #20;

        // Player selects tile 1
        input_switches = 9'b000000010;
        #20;
        tiles = 17'b0000_0000_0000_0101_11;

        // Player selects an already occupied tile (invalid move)
        input_switches = 9'b000000001;
        #20;

        // Player selects tile 8
        input_switches = 9'b100000000;
        #20;

        // End simulation
        $stop;
    end

endmodule
