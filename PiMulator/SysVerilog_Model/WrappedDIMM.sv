/* Machine-generated using Migen */
module WrappedDIMM(
    input act_n,
    input [16:0] addr,
    input [1:0] wrappeddimm,
    input [1:0] ba,
    input ck2x,
    input ck_c,
    input ck_t,
    input reset_n,
    input cke,
    input cs_n,
    inout [63:0] dq,
    inout [15:0] dqs_c,
    inout [15:0] dqs_t,
    input odt,
    input parity,
    output stall
);



    DIMM #(
    .ADDRWIDTH(17),
    .BAWIDTH(2),
    .BGWIDTH(2),
    .BL(8),
    .CHIPS(16),
    .CHWIDTH(5),
    .COLWIDTH(10),
    .DEVICE_WIDTH(4),
    .RANKS(1)
    ) WrappedDIMMi (
        .A(addr),
        .act_n(act_n),
        .ba(ba),
        .bg(wrappeddimm),
        .ck2x(ck2x),
        .ck_cn(ck_c),
        .ck_tp(ck_t),
        .cke(cke),
        .cs_n(cs_n),
        .odt(odt),
        .parity(parity),
        .reset_n(reset_n),
        .dq(dq),
        .dqs_cn(dqs_c),
        .dqs_tp(dqs_t),
        .stall(stall)
    );

endmodule
