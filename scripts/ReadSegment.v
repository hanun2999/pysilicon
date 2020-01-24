
`timescale 1ns/1ps

// Read-only scan-chain segment

module ReadSegment(
        SClkP,
        SClkN,
        SEnable,
        CfgIn,
        SIn,
        SOut
    );

    //-----------------------------------------------------------------------------------
    //    Parameters
    //-----------------------------------------------------------------------------------
    parameter PWidth =              8;
    parameter TwoPhase =            1;
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //    I/O
    //-----------------------------------------------------------------------------------
    input wire                      SClkP;
    input wire                      SClkN;
    input wire                      SEnable;
    input wire   [PWidth-1:0]       CfgIn;
    input wire                      SIn;
    output wire                     SOut;
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //    Signals
    //-----------------------------------------------------------------------------------
    reg         [PWidth-1:0]        M;
    reg         [PWidth-1:0]        Q;
    wire        [PWidth-1:0]        NextVal;
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //    Assigns
    //-----------------------------------------------------------------------------------
    assign SOut =                   Q[PWidth-1];

    //Most significant bit is the first bit that is shifted in
    generate if (PWidth <= 1) begin
        assign NextVal = (SEnable) ? SIn : CfgIn;
    end else begin
        assign NextVal = (SEnable) ? {Q[PWidth-2:0], SIn} : CfgIn;
    end endgenerate
    //-----------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------
    //    Chain
    //-----------------------------------------------------------------------------------
    generate if (TwoPhase == 1) begin
        always @ ( * ) if (SClkN) M = NextVal;
        always @ ( * ) if (SClkP) Q = M;
    end else begin
        always @ (posedge SClkP) Q <= NextVal;
    end endgenerate
    //-----------------------------------------------------------------------------------
endmodule