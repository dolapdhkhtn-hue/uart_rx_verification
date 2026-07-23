class apb_sequence extends uvm_sequence #(apb_item);
  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  task body();
    apb_item item;

    // Đọc thanh ghi RX data (offset 0)
    item = apb_item::type_id::create("item");
    start_item(item);
    if (!item.randomize() with { p_addr == 8'd4; })
      `uvm_error("APB_SEQ", "Randomize failed")
    finish_item(item);
  endtask
endclass