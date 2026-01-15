// SPDX-License-Identifier: CERN-OHL-W-2.0
//
// This source describes Open Hardware and is licensed under the CERN-OHL-W v2.
// 
// You may redistribute and modify this source and make products using it under
// the terms of the CERN-OHL-W v2 (Weakly Reciprocal).
//
// The Documentation and source code for this project are available at:
// https://github.com/JPL24hub/EVMx
//
// COPYRIGHT (C) 2025 Joel Poncha Lemayian
//--------------------------------------------------------------------------------------
// FILE:        non_rest_div.sv
// ENGINEER:    Poncha Lemayian
// REVISION:    1.2 - 13/02/2025 - File created.
// DESCRIPTION: 
// COMMENTS:    Implementing a non-restoring division algorithm. Handles edge cases.
//--------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module non_rest_div #(
    parameter WIDTH = 256
)(
    input  logic clk,                      // Clock signal
    input  logic rst,                      // Reset signal (active low)
    input  logic [WIDTH-1:0] dividend,     // Numerator
    input  logic [WIDTH-1:0] divisor,      // Denominator
    input  logic start,                    // Start signal
    output logic ready,                    // Ready signal
    output logic [WIDTH-1:0] remainder,    // Remainder result
    output logic [WIDTH-1:0] quotient      // Quotient result
);
    // Constants
    localparam [WIDTH-1:0] ZEROS = '0;
    localparam [WIDTH-1:0] ONE = {{(WIDTH-1){1'b0}}, 1'b1};
    
    // Registers and their next values
    logic [WIDTH-1:0] regA, regA_nxt;
    logic [WIDTH-1:0] regQ, regQ_nxt;
    logic [WIDTH-1:0] regM, regM_nxt;
    logic [WIDTH-1:0] sigALU, sigLS;
    
    // Control signals
    logic selM, op, enCntr, selRmr;
    logic [1:0] selA, selQnt;
    logic [2:0] selQ;
    
    // Counter
    integer counter, counter_nxt;
    
    // State machine
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        SHIFT,
        ADD_STATE,
        SUB_STATE,
        QSTATE,
        WATISN,
        DONE
    } states_t;
    
    states_t reg_state, next_state;
    
    //===========================================
    // Sequential Logic - Register Updates
    //===========================================
    always_ff @(posedge clk) begin
        if (!rst) begin
            regA    <= '0;
            regQ    <= '0;
            regM    <= '0;
            counter <= 0;
        end
        else begin
            regA    <= regA_nxt;
            regQ    <= regQ_nxt;
            regM    <= regM_nxt;
            counter <= counter_nxt;
        end
    end
    
    //===========================================
    // Register A Logic
    //===========================================
    always_comb begin
        case (selA)
            2'b00:   regA_nxt = regA;     // Hold A
            2'b01:   regA_nxt = sigALU;   // ALU operation
            default: regA_nxt = sigLS;    // Shift A left
        endcase
    end
    
    assign sigLS = {regA[WIDTH-2:0], regQ[WIDTH-1]};  // Shift A left
    assign sigALU = op ? (regA + ~regM + 1'b1) : (regA + regM);  // Subtract or Add
    
    //===========================================
    // Register Q Logic
    //===========================================
    always_comb begin
        case (selQ)
            3'b000:  regQ_nxt = regQ;                           // Retain Q
            3'b001:  regQ_nxt = {regQ[WIDTH-2:0], 1'b0};       // Shift Q left
            3'b010:  regQ_nxt = {regQ[WIDTH-1:1], 1'b0};       // Q(0) = 0
            3'b011:  regQ_nxt = {regQ[WIDTH-1:1], 1'b1};       // Q(0) = 1
            default: regQ_nxt = dividend;                       // Load Q
        endcase
    end
    
    //===========================================
    // Register M Logic
    //===========================================
    assign regM_nxt = selM ? divisor : regM;  // Load M or hold
    
    //===========================================
    // Counter Logic
    //===========================================
    assign counter_nxt = enCntr ? (counter + 1) : counter;
    
    //===========================================
    // Output Logic
    //===========================================
    always_comb begin
        case (selQnt)
            2'b00:   quotient = regQ;      // Quotient
            2'b01:   quotient = ZEROS;     // Zero
            2'b10:   quotient = dividend;  // Dividend
            default: quotient = ONE;       // One
        endcase
    end
    
    assign remainder = selRmr ? ZEROS : regA;
    
    //===========================================
    // State Machine - Sequential
    //===========================================
    always_ff @(posedge clk) begin
        if (!rst)
            reg_state <= IDLE;
        else
            reg_state <= next_state;
    end
    
    //===========================================
    // State Machine - Combinational
    //===========================================
    always_comb begin
        // Default outputs
        op      = 0;
        ready   = 0;
        selA    = 2'b00;
        selQ    = 3'b000;
        selM    = 0;
        enCntr  = 0;
        selRmr  = 0;
        selQnt  = 2'b00;
        next_state = reg_state;
        
        case (reg_state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            end
            
            LOAD: begin
                selM = 1;      // Load M
                selQ = 3'b100; // Load Q
                
                if (divisor == 1) begin
                    selRmr = 1;     // Remainder = 0
                    selQnt = 2'b10; // Quotient = dividend
                    ready = 1;
                    next_state = IDLE;
                end
                else if ((dividend < divisor) || (divisor == 0)) begin
                    selRmr = 1;     // Remainder = 0
                    selQnt = 2'b01; // Quotient = 0
                    ready = 1;
                    next_state = IDLE;
                end
                else if (dividend == divisor) begin
                    selRmr = 1;     // Remainder = 0
                    selQnt = 2'b11; // Quotient = 1
                    ready = 1;
                    next_state = IDLE;
                end
                else begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin  // Shift left AQ
                selA = 2'b10;   // Shift A
                selQ = 3'b001;  // Shift Q
                
                if (regA[WIDTH-1])
                    next_state = ADD_STATE;
                else begin
                    op = 0;  // A = A + M (actually will be subtracted in SUB_STATE)
                    next_state = SUB_STATE;
                end
            end
            
            ADD_STATE: begin
                selA = 2'b01;  // A = A + M
                next_state = QSTATE;
            end
            
            SUB_STATE: begin
                op = 1;        // A = A - M
                selA = 2'b01;  // A = A - M
                next_state = QSTATE;
            end
            
            QSTATE: begin
                enCntr = 1;  // Enable counter
                
                if (regA[WIDTH-1]) begin
                    selQ = 3'b010;  // Q(0) = 0
                    next_state = WATISN;
                end
                else begin
                    selQ = 3'b011;  // Q(0) = 1
                    next_state = WATISN;
                end
            end
            
            WATISN: begin
                if (counter == WIDTH) begin
                    if (regA[WIDTH-1])
                        selA = 2'b01;  // A = A + M
                    next_state = DONE;
                end
                else begin
                    next_state = SHIFT;
                end
            end
            
            DONE: begin
                ready = 1;
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule