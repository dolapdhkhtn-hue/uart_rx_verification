// ============================================================
// AGENT
// ============================================================
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver  drv;
    seqcr   seqr;
    monitor mon;

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            $display("Agent build_phase, UVM_ACTIVE");
            drv  = driver::type_id::create("drv",  this);
            seqr = seqcr::type_id::create("seqr",  this);
        end
        mon = monitor::type_id::create("mon", this);
        $display("Agent build_phase, end");
    endfunction

    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
        $display("Agent connect_phase");
    endfunction
endclass