lass driver_reset extends uvm_driver #(reset_item);
    `uvm_component_utils(driver_reset)

    virtual reset_itf reset_face;
    function new(string name = "driver_reset", uvm_component parent = null);
            super.new(name,parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual reset_itf)::get(this,"","vif_reset", reset_face))begin
            `uvm_fatal(get_type_name(),"Not set up at top lever")
        end
    endfunction 

    task run_phase(uvm_phase phase);
            forever begin
                seq_item_port.get_next_item(req);
                    reset_face.reset_n <= req.reset_n;
                    repeat(5)@(posedge reset_face.clk);
                    reset_face.reset_n <= 1'b1;
                seq_item_port.item_done();
            end
    endtask
endclass