

class env extends uvm_env;
    `uvm_component_utils(env)

    scoreboard sb;
    agent_uart uart_1;
    agent_apb  apb_1;
    agent_reset reset_1;
    virtual_sequencer vseqr;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_1 = agent_uart::type_id::create("uart_1", this);
        apb_1 = agent_apb::type_id::create("apb_1", this);
        reset_1 = agent_reset::type_id::create("reset_1", this);
        sb  = scoreboard::type_id::create("sb",  this);
        vseqr   = virtual_sequencer::type_id::create("vseqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        uart_1.mon_uart.monitor_uart_collect_port.connect(sb.uart_item_collect_export);
        apb_1.mon_apb.monitor_apb_collect_port.connect(sb.apb_item_collect_export);

        vseqr.uart_seqr  = uart_1.seq_uart;
        vseqr.apb_seqr   = apb_1.seq_apb;
        vseqr.reset_seqr = reset_1.seq_reset;
    endfunction
endclass