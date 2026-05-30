// ============================================================
// DRIVER
// ============================================================
class driver extends uvm_driver #(seq_item);
    virtual uart_if vif;

    localparam B_COUNT = 868; // 100MHz / 115200

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual uart_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Not set at top level")
    endfunction


    // Gửi 1 byte UART: start bit → 8 bit LSB first → stop bit
    task send_uart_byte(input logic [7:0] data);
        // Start bit
        vif.rx <= 1'b0;
        repeat(B_COUNT) @(posedge vif.clk);
        // 8 data bit
        for (int i = 0; i < 8; i++) begin
            vif.rx <= data[i];
            repeat(B_COUNT) @(posedge vif.clk);
        end
        // Stop bit
        vif.rx <= 1'b1;
        repeat(B_COUNT) @(posedge vif.clk);
    endtask

    // Đọc 1 thanh ghi qua APB
    task apb_read(input logic [7:0] addr);
        @(posedge vif.clk);
        vif.p_addr     <= addr;
        vif.p_write    <= 1'b0;
        vif.p_sel_uart <= 1'b1;
        vif.p_enable   <= 1'b0;
        @(posedge vif.clk);
        vif.p_enable   <= 1'b1;
        @(posedge vif.clk);
        vif.p_sel_uart <= 1'b0;
        vif.p_enable   <= 1'b0;
    endtask

    task run_phase(uvm_phase phase);
        // Khởi tạo tín hiệu
        vif.reset_n    <= 1'b0;
        vif.rx         <= 1'b1;
        vif.p_sel_uart <= 1'b0;
        vif.p_enable   <= 1'b0;
        vif.p_write    <= 1'b0;
        vif.p_addr     <= 8'h00;
        repeat(10) @(posedge vif.clk);
        vif.reset_n    <= 1'b1;
        repeat(5)  @(posedge vif.clk);

        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info(get_type_name(),
                $sformatf("Sending byte: 0x%02X", req.data), UVM_LOW)

            // CHECK 1: Đọc done_flag trước khi gửi → expect 0x00
            apb_read(8'h00);

            // Gửi frame UART
            send_uart_byte(req.data);

            // Chờ DUT chuyển sang DONE
            repeat(B_COUNT) @(posedge vif.clk);

            // CHECK 2: Đọc done_flag sau khi nhận xong → expect 0x01
            apb_read(8'h00);

            // CHECK 3: Đọc RX_DATA → expect = data gốc
            // (đọc RX_DATA tự động clear done_flag trong DUT)
            apb_read(8'h04);

            // Chờ 2 clock để DUT cập nhật done_flag
            repeat(2) @(posedge vif.clk);

            // CHECK 4: Đọc lại done_flag → expect 0x00
            apb_read(8'h00);

            seq_item_port.item_done();
        end
    endtask
endclass