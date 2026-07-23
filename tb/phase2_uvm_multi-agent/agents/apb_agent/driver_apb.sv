class driver_apb extends uvm_driver #(apb_item);
    `uvm_component_utils(driver_apb)
    virtual apb_itf apb_face;

    function new(string name = "driver_apb", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual apb_itf)::get(this,"","vif_apb", apb_face )) begin
            `uvm_fatal(get_type_name(),"Not set at top lever")
        end
    endfunction
    task read_apb(input logic p_write, input logic p_sel_uart, input logic p_enable, input logic [7:0] p_addr);
         //Phase 1: Setup
         @(posedge apb_face.clk);
         apb_face.p_write <= p_write;
         apb_face.p_enable   <= 1'b0;
         apb_face.p_sel_uart <= p_sel_uart;
         
         apb_face.p_addr <= p_addr;
         // Phase 2: Access
         @(posedge apb_face.clk);
         apb_face.p_enable <= p_enable;
        //  @(posedge apb_face.clk);
        //     apb_face.p_sel_uart <= 1'b0;
        //     apb_face.p_enable   <= 1'b0;
    endtask

    task run_phase(uvm_phase phase);
            forever begin
                seq_item_port.get_next_item(req);
                    read_apb(req.p_write, req.p_sel_uart,req.p_enable, req.p_addr);
                seq_item_port.item_done();
            end
    endtask
    
endclass