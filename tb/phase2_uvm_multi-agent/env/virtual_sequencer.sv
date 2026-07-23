class virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(virtual_sequencer)

    sequencer_uart  uart_seqr;
    sequencer_apb   apb_seqr;
    sequencer_reset reset_seqr;

    function new(string name = "virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass