// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Generic Counter Flop
 *
 * Counter flop implementation for non-Xilinx targets
 */
module ibex_counter_flop_xilinx #(
  parameter int                      CounterWidth = 32,
  parameter logic [CounterWidth-1:0] ResetValue = 0
) (
  input  logic                    clk_i,
  input  logic                    rst_ni,
  input  logic [CounterWidth-1:0] d_i,
  output logic [CounterWidth-1:0] q_o
);
  // On Xilinx FPGAs, 48-bit DSPs are available that can be used for the
  // counter. When using a DSP, a sync. reset is needed for the flop.
  localparam string ResetType = CounterWidth < 49 ? "SYNC" : "ASYNC";

  generate
    if(ResetType == "ASYNC") begin : g_async_reset_ff
      always_ff @(posedge clk_i  or negedge rst_ni) begin
        if (!rst_ni) begin
          q_o <= ResetValue;
        end else begin
          q_o <= d_i;
        end
      end
    end else begin : g_sync_reset_ff
      always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
          q_o <= ResetValue;
        end else begin
          q_o <= d_i;
        end
      end
    end
  endgenerate

endmodule
