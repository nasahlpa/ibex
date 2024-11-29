// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Generic Counter Flop
 *
 * Counter flop implementation for non-Xilinx targets
 */
module ibex_counter_flop_generic #(
  parameter int CounterWidth = 32
) (
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic [CounterWidth-1:0] counter_i,
  output logic [CounterWidth-1:0] counter_o
);
  logic [CounterWidth-1:0] counter_q, counter_d;
  assign counter_o = counter_q;
  assign counter_d = counter_i;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      counter_q <= '0;
    end else begin
      counter_q <= counter_d;
    end
  end

endmodule
