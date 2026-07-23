class sequencer_uart extends uvm_sequencer #(uart_item);
    `uvm_component_utils(sequencer_uart)

    function new (string name = "sequencer_uart", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass