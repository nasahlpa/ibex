// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Generic Counter Flop
 *
 * Counter flop implementation for non-Xilinx targets
 */
module ibex_counter_flop_xilinx #(
  parameter int CounterWidth = 32
) (
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic [CounterWidth-1:0] counter_i,
  output logic [CounterWidth-1:0] counter_o
);
  // On Xilinx FPGAs, 48-bit DSPs are available that can be used for the
  // counter.
  localparam int DspPragma = CounterWidth < 49 ? "yes" : "no";
  (* use_dsp = DspPragma *) logic [CounterWidth-1:0] counter_q;
  // When using a DSP, a sync. reset is needed for the flop.
  localparam string ResetType = CounterWidth < 49 ? "SYNC" : "ASYNC";

  // Flop with async. reset.
  `define ASYNC_RST_FF(CLK, RST_NI, Q, D) \
    always_ff @(posedge CLK or negedge RST_NI) begin \
      if (!RST_NI) begin \
        Q <= '0; \
      end else begin \
        Q <= D; \
      end \
    end

  // Flop with sync. reset.
  `define SYNC_RST_FF(CLK, RST_NI, Q, D) \
    always_ff @(posedge CLK) begin \
      if (!RST_NI) begin \
        Q <= '0; \
      end else begin \
        Q <= D; \
      end \
    end

  logic [CounterWidth-1:0] counter_d;
  assign counter_o = counter_q;
  assign counter_d = counter_i;

  generate
    if(ResetType == "ASYNC") begin : g_async_reset_ff
      `ASYNC_RST_FF(clk_i, rst_ni, counter_q, counter_d);
      `undef ASYNC_RST_FF
    end else begin : g_sync_reset_ff
      `SYNC_RST_FF(clk_i, rst_ni, counter_q, counter_d);
      `undef SYNC_RST_FF
    end
  endgenerate

endmodule
