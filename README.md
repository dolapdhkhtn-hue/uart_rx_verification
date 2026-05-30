# UART_RX Verification — SystemVerilog OOP & UVM

## Overview
Verification project for a UART RX module (Verilog HDL) using two methodologies:
- **Phase 1**: Class-based Testbench (SystemVerilog OOP)
- **Phase 2**: UVM Framework (IEEE 1800.2)

## Module Specification
| Parameter     | Value              |
|---------------|--------------------|
| Clock         | 100 MHz            |
| Baud Rate     | 115200 bps         |
| Data Width    | 8-bit, LSB first   |
| CPU Interface | APB Bus            |
| FSM States    | IDLE→START→RECEIVE→STOP→DONE |

## Testbench Architecture
### Phase 1 — Class-based
- Transaction, Generator, Driver, Monitor, Scoreboard
- Communication via SystemVerilog Mailbox

### Phase 2 — UVM
- uvm_sequence_item, uvm_sequence, uvm_driver, uvm_monitor
- TLM Analysis Port/Export

## Test Results
| Test Group       | Test Cases | Result              |
|------------------|------------|---------------------|
| Functional Test  | 6          | 5 PASS / 1 FAIL*    |
| Protocol (APB)   | 5          | 5 PASS              |
| Coverage         | 5 bins     | 100% hit            |

*BUG-01: FSM stuck at STOP state when STOP bit = 0 → Reported to designer with fix proposal

## Bug Found
**BUG-01 (CRITICAL):** When STOP bit = 0, condition `rx==1 && count==B_COUNT-1`
never meets → FSM hangs at STOP state → module loses sync.

**Proposed Fix:**
```verilog
STOP: begin
  if(count_baud_tick == B_COUNT - 1) begin
    if(rx == 1) next_state = DONE;
    else        next_state = IDLE; // Handle invalid STOP bit
  end
end
```

## Tools
- Simulator: Xilinx Vivado
- Language: SystemVerilog, UVM

