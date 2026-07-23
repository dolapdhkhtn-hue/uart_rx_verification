class uart_sequence extends uvm_sequence #(uart_item);
  `uvm_object_utils(uart_sequence)

  function new(string name = "uart_sequence");
    super.new(name);
  endfunction

  task body();
    uart_item item;
    item = uart_item::type_id::create("item");
    start_item(item);
    if (!item.randomize())
      `uvm_error("UART_SEQ", "Randomize failed")
    finish_item(item);
  endtask
endclass