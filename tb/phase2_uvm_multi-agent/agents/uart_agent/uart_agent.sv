class agent_uart extends uvm_agent;
    `uvm_component_utils(agent_uart)

    sequencer_uart seq_uart;
    driver_uart    drv_uart;
    monitor_uart   mon_uart;

    function new (string name = "agent_uart", uvm_component parent =null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            seq_uart = sequencer_uart::type_id::create("seq_uart", this);
            drv_uart = driver_uart::type_id::create("drv_uart", this);
        end
        
        mon_uart = monitor_uart::type_id::create("mon_uart", this);
    endfunction

    function void connect_phase(uvm_phase phase);
         if(get_is_active() == UVM_ACTIVE) begin
            drv_uart.seq_item_port.connect(seq_uart.seq_item_export);
            $display("Agent connect_phase");
         end
    endfunction
endclass