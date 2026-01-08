module twophaseOsc (
    input wire clk,
    output wire cos,                     // MSB of cosine (sign bit)
    output wire sin,                     // MSB of sine (sign bit)
    output wire [24-1:0] x,   // Cosine output
    output wire [24-1:0] y    // Sine output
);
    // Constants
    localparam PHASE_WIDTH = 32;
    localparam FREQ_WORD = 32'd42949673;  // Default frequency control word
    localparam OUTPUT_WIDTH = 24;


    // Phase accumulator
    reg [PHASE_WIDTH-1:0] phase_acc;
    
    // LUT address (use upper bits of phase)
    localparam LUT_ADDR_WIDTH = 10;
    wire [LUT_ADDR_WIDTH-1:0] lut_addr;
    
    // Quadrant detection
    wire [1:0] quadrant;
    wire [LUT_ADDR_WIDTH-1:0] lut_index;
    
    // Raw LUT outputs
    reg [OUTPUT_WIDTH-2:0] cos_lut;
    reg [OUTPUT_WIDTH-2:0] sin_lut;
    
    // Signed outputs
    reg signed [OUTPUT_WIDTH-1:0] x_reg;
    reg signed [OUTPUT_WIDTH-1:0] y_reg;
    
    // Phase accumulator - increments every clock
    always @(posedge clk) begin
        phase_acc <= phase_acc + FREQ_WORD;
    end
    
    // Extract quadrant and LUT address from phase
    assign quadrant = phase_acc[PHASE_WIDTH-1:PHASE_WIDTH-2];
    assign lut_addr = phase_acc[PHASE_WIDTH-3:PHASE_WIDTH-3-LUT_ADDR_WIDTH+1];
    
    // Create symmetrical LUT index (0 to 2^LUT_ADDR_WIDTH-1 then back down)
    assign lut_index = (lut_addr[LUT_ADDR_WIDTH-1]) ? 
                       (~lut_addr) : lut_addr;
    
    // Sine/Cosine LUT (quarter wave) - scaled for 24-bit output
    always @(*) begin
        case(lut_index)
            10'd0:   sin_lut = 23'd0;
            10'd1:   sin_lut = 23'd205824;
            10'd2:   sin_lut = 23'd411648;
            10'd3:   sin_lut = 23'd616960;
            10'd4:   sin_lut = 23'd822272;
            10'd5:   sin_lut = 23'd1026816;
            10'd6:   sin_lut = 23'd1230848;
            10'd7:   sin_lut = 23'd1434112;
            10'd8:   sin_lut = 23'd1636608;
            10'd9:   sin_lut = 23'd1837824;
            10'd10:  sin_lut = 23'd2038016;
            10'd11:  sin_lut = 23'd2237184;
            10'd12:  sin_lut = 23'd2435072;
            10'd13:  sin_lut = 23'd2631168;
            10'd14:  sin_lut = 23'd2825984;
            10'd15:  sin_lut = 23'd3019008;
            10'd16:  sin_lut = 23'd3209984;
            10'd17:  sin_lut = 23'd3399424;
            10'd18:  sin_lut = 23'd3586560;
            10'd19:  sin_lut = 23'd3771392;
            10'd20:  sin_lut = 23'd3954176;
            10'd21:  sin_lut = 23'd4134656;
            10'd22:  sin_lut = 23'd4312576;
            10'd23:  sin_lut = 23'd4487680;
            10'd24:  sin_lut = 23'd4660224;
            10'd25:  sin_lut = 23'd4830208;
            10'd26:  sin_lut = 23'd4996864;
            10'd27:  sin_lut = 23'd5160704;
            10'd28:  sin_lut = 23'd5321472;
            10'd29:  sin_lut = 23'd5479168;
            10'd30:  sin_lut = 23'd5633280;
            10'd31:  sin_lut = 23'd5784064;
            10'd32:  sin_lut = 23'd5931520;
            10'd33:  sin_lut = 23'd6075136;
            10'd34:  sin_lut = 23'd6215424;
            10'd35:  sin_lut = 23'd6351872;
            10'd36:  sin_lut = 23'd6484736;
            10'd37:  sin_lut = 23'd6613760;
            10'd38:  sin_lut = 23'd6738944;
            10'd39:  sin_lut = 23'd6860288;
            10'd40:  sin_lut = 23'd6977792;
            10'd41:  sin_lut = 23'd7091456;
            10'd42:  sin_lut = 23'd7201280;
            10'd43:  sin_lut = 23'd7307264;
            10'd44:  sin_lut = 23'd7409408;
            10'd45:  sin_lut = 23'd7507712;
            10'd46:  sin_lut = 23'd7602176;
            10'd47:  sin_lut = 23'd7692800;
            10'd48:  sin_lut = 23'd7779584;
            10'd49:  sin_lut = 23'd7862528;
            10'd50:  sin_lut = 23'd7941632;
            default: sin_lut = 23'd8388607;  // Max value for 23-bit
        endcase
    end
    
    // Apply quadrant symmetry
    always @(posedge clk) begin
        case(quadrant)
            2'b00: begin  // 0-90 degrees
                x_reg <= {1'b0, sin_lut};  // cos positive
                y_reg <= {1'b0, sin_lut};  // sin positive
            end
            2'b01: begin  // 90-180 degrees
                x_reg <= {1'b1, ~sin_lut}; // cos negative
                y_reg <= {1'b0, sin_lut};  // sin positive
            end
            2'b10: begin  // 180-270 degrees
                x_reg <= {1'b1, ~sin_lut}; // cos negative
                y_reg <= {1'b1, ~sin_lut}; // sin negative
            end
            2'b11: begin  // 270-360 degrees
                x_reg <= {1'b0, sin_lut};  // cos positive
                y_reg <= {1'b1, ~sin_lut}; // sin negative
            end
        endcase
    end
    
    // Outputs
    assign x = x_reg;
    assign y = y_reg;
    assign cos = x_reg[OUTPUT_WIDTH-1];  // Sign bit of cosine
    assign sin = y_reg[OUTPUT_WIDTH-1];  // Sign bit of sine

endmodule