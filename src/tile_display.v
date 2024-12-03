module tile_display(
    input clk,
    input reset,
    input [17:0] tiles,
    input [8:0] color,
    
    output vsync,
    output hsync,
    output [11:0] rgb
    );

    // VGA constants
    parameter TOTAL_COLS = 640; // horizonal columns
    parameter TOTAL_ROWS = 480; // vertical rows

    parameter HORIZ_BORDER = 100; // horizontal borders
    parameter VERT_BORDER = 20; // vertical borders

    parameter VERT_LINE1 = HORIZ_BORDER + 147; // position of 1st vertical line
    parameter VERT_LINE2 = TOTAL_COLS - 167; // position of 2nd vertical line

    parameter HORIZ_LINE1 = VERT_BORDER + 147; // position of 1st horizontal line 
    parameter HORIZ_LINE2 = TOTAL_ROWS - 247; // position of 2nd horizontal line 

    parameter SQUARE_BORDER = 40; // distance between squares and grid

    parameter PLUS_BORDER = 30; // distance between plus sign and grid

    parameter LINE_WEIGHT = 2;

    reg [1:0] display;

    wire [9:0] horiz_pos, vert_pos;

    wire tick; 

    vga_sync vga_driver (
        .clk(clk), 
        .reset(reset), 
        .hsync(hsync), 
        .vsync(vsync),
        .video_on(), 
        .p_tick(tick), 
        .x(horiz_pos), 
        .y(vert_pos)
    );


    always @(posedge tick) begin

        display = 2'b00;
        
        if (horiz_pos > HORIZ_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) &&
            ((vert_pos > HORIZ_LINE1 - LINE_WEIGHT && vert_pos < HORIZ_LINE1 + LINE_WEIGHT) ||
            (vert_pos > HORIZ_LINE2 - LINE_WEIGHT && vert_pos < HORIZ_LINE2 + LINE_WEIGHT))) 
        begin
            display = 2'b01;
        end

        else if (vert_pos > VERT_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) &&
            ((horiz_pos > VERT_LINE1 - LINE_WEIGHT && horiz_pos < VERT_LINE1 + LINE_WEIGHT) ||
            (horiz_pos > VERT_LINE2 - LINE_WEIGHT && horiz_pos < VERT_LINE2 + LINE_WEIGHT))) 
        begin
            display = 2'b01;
        end

        // Tile 1
        else if (((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + (tiles[1] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - (tiles[1] ? 0 : PLUS_BORDER) && 
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) || 
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + (tiles[1] ? 0 : PLUS_BORDER) &&
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - (tiles[1] ? 0 : PLUS_BORDER) )) && tiles[0] ) 
        begin
            display = {color[0], 1'b1};
        end

        // Tile 2
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + (tiles[3] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - (tiles[3] ? 0 : PLUS_BORDER) &&
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + (tiles[3] ? 0 : PLUS_BORDER) && 
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - (tiles[3] ? 0 : PLUS_BORDER))) && tiles[2])
        begin
            display = {color[1], 1'b1};
        end

        // Tile 3
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + (tiles[5] ? 0 : PLUS_BORDER) && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - (tiles[5] ? 0 : PLUS_BORDER) &&
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + (tiles[5] ? 0 : PLUS_BORDER) && 
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - (tiles[5] ? 0 : PLUS_BORDER))) && tiles[4])
        begin
            display = {color[2], 1'b1};
        end

        // Tile 4
        else if (
            ((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + (tiles[7] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - (tiles[7] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + (tiles[7] ? 0 : PLUS_BORDER) && 
            vert_pos < HORIZ_LINE2 - SQUARE_BORDER - (tiles[7] ? 0 : PLUS_BORDER))) && tiles[6])
        begin
            display = {color[3], 1'b1};
        end

        // Tile 5
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + (tiles[9] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - (tiles[9] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + (tiles[9] ? 0 : PLUS_BORDER) 
            && vert_pos < HORIZ_LINE2 - SQUARE_BORDER - (tiles[9] ? 0 : PLUS_BORDER))) && tiles[8])
        begin
            display = {color[4], 1'b1};
        end

        // Tile 6
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + (tiles[11] ? 0 : PLUS_BORDER) && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - (tiles[11] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + (tiles[11] ? 0 : PLUS_BORDER) && 
            vert_pos < HORIZ_LINE2 - SQUARE_BORDER - (tiles[11] ? 0 : PLUS_BORDER))) && tiles[10])
        begin
            display = {color[5], 1'b1};
        end

        // Tile 7
        else if (
            ((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + (tiles[13] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - (tiles[13] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + (tiles[13] ? 0 : PLUS_BORDER) && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - (tiles[13] ? 0 : PLUS_BORDER))) && tiles[12])
        begin
            display = {color[6], 1'b1};
        end

        // Tile 8
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + (tiles[15] ? 0 : PLUS_BORDER) && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - (tiles[15] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + (tiles[15] ? 0 : PLUS_BORDER) && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - (tiles[15] ? 0 : PLUS_BORDER))) && tiles[14])
        begin
            display = {color[7], 1'b1};
        end

        // Tile 9
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + (tiles[17] ? 0 : PLUS_BORDER) && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - (tiles[17] ? 0 : PLUS_BORDER) &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + (tiles[17] ? 0 : PLUS_BORDER) && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - (tiles[17] ? 0 : PLUS_BORDER))) && tiles[16])
        begin
            display = {color[8], 1'b1};
        end
        else 
            display = 2'b00;


    end

    // 12 bits: first four red, second four green, third four blue

    assign rgb = (display[0]) ? (display[1] ? 12'hF00 : 12'hFFF) : 12'h0;

endmodule
