module tile_display(
    input clk,
    input [17:0] tiles,
    input [8:0] color,
    
    output vsync,
    output hsync,
    output reg [11:0] rgb
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
        .reset(), 
        .hsync(hsync), 
        .vsync(vsync),
        .video_on(), 
        .p_tick(tick), 
        .x(horiz_pos), 
        .y(vert_pos)
    );

    // intermediate wires
    wire [17:0] tile_cond;
    
    genvar i;
    generate
        for (i = 0; i < 18; i = i + 1) begin
            assign tile_cond[i] = tiles[i] ? 0 : PLUS_BORDER;
        end
    endgenerate



    always @(posedge tick) begin
        
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
        else if (((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + tile_cond[1] && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - tile_cond[1] && 
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) || 
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + tile_cond[1] &&
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - tile_cond[1] )) && tiles[0] ) 
        begin
            display = {color[0], 1'b1};
        end

        // Tile 2
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + tile_cond[3] && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - tile_cond[3] &&
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + tile_cond[3] && 
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - tile_cond[3])) && tiles[2])
        begin
            display = {color[1], 1'b1};
        end

        // Tile 3
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + tile_cond[5] && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - tile_cond[5] &&
            vert_pos > VERT_BORDER + SQUARE_BORDER && vert_pos < HORIZ_LINE1 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > VERT_BORDER + SQUARE_BORDER + tile_cond[5] && 
            vert_pos < HORIZ_LINE1 - SQUARE_BORDER - tile_cond[5])) && tiles[4])
        begin
            display = {color[2], 1'b1};
        end

        // Tile 4
        else if (
            ((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + tile_cond[7] && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - tile_cond[7] &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + tile_cond[7] && 
            vert_pos < HORIZ_LINE2 - SQUARE_BORDER - tile_cond[7])) && tiles[6])
        begin
            display = {color[3], 1'b1};
        end

        // Tile 5
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + tile_cond[9] && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - tile_cond[9] &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + tile_cond[9] 
            && vert_pos < HORIZ_LINE2 - SQUARE_BORDER - tile_cond[9])) && tiles[8])
        begin
            display = {color[4], 1'b1};
        end

        // Tile 6
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + tile_cond[11] && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - tile_cond[11] &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER && vert_pos < HORIZ_LINE2 - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE1 + SQUARE_BORDER + tile_cond[11] && 
            vert_pos < HORIZ_LINE2 - SQUARE_BORDER - tile_cond[11])) && tiles[10])
        begin
            display = {color[5], 1'b1};
        end

        // Tile 7
        else if (
            ((horiz_pos > HORIZ_BORDER + SQUARE_BORDER + tile_cond[13] && 
            horiz_pos < VERT_LINE1 - SQUARE_BORDER - tile_cond[13] &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > HORIZ_BORDER + SQUARE_BORDER && horiz_pos < VERT_LINE1 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + tile_cond[13] && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - tile_cond[13])) && tiles[12])
        begin
            display = {color[6], 1'b1};
        end

        // Tile 8
        else if (
            ((horiz_pos > VERT_LINE1 + SQUARE_BORDER + tile_cond[15] && 
            horiz_pos < VERT_LINE2 - SQUARE_BORDER - tile_cond[15] &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE1 + SQUARE_BORDER && horiz_pos < VERT_LINE2 - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + tile_cond[15] && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - tile_cond[15])) && tiles[14])
        begin
            display = {color[7], 1'b1};
        end

        // Tile 9
        else if (
            ((horiz_pos > VERT_LINE2 + SQUARE_BORDER + tile_cond[17] && 
            horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER - tile_cond[17] &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER && vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER) ||
            (horiz_pos > VERT_LINE2 + SQUARE_BORDER && horiz_pos < (TOTAL_COLS - HORIZ_BORDER) - SQUARE_BORDER &&
            vert_pos > HORIZ_LINE2 + SQUARE_BORDER + tile_cond[17] && 
            vert_pos < (TOTAL_ROWS - VERT_BORDER) - SQUARE_BORDER - tile_cond[17])) && tiles[16])
        begin
            display = {color[8], 1'b1};
        end


    end

// 12 bits: first four red, second four green, third four blue

    always @(*) begin
        if (display[0]) begin
            if (display[1])
                rgb = 12'b111100000000; // red (red only)
            else
                rgb = 12'b111111111111; // white (all colors)
        end
        else 
            rgb = 12'b000000000000; // black (nothing displayed)
    end
endmodule
