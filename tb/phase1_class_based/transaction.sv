class transaction;
    rand bit [7:0] data;
    bit [7:0] data_out;
    
    constraint data_input { data dist 
        {   8'h00 := 200,   // all zero
            8'hFF := 200,   // all one
            8'hAA := 200,   // xen ke 10101010
            8'h55 := 200,   // xen ke 01010101
            [8'h01:8'hFE] := 6  // ngau nhien
        }; }
endclass