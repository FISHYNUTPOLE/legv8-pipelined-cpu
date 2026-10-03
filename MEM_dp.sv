module MEM_dp (input  logic clk, reset, 
               input  logic memWrite, 
               input  logic [63:0] aluOut, memWriteData,
               output logic [63:0] dmem_out);

    datamem dmem (.address(aluOut),
	              .write_enable(memWrite),
	              .read_enable(1'b1),
	              .write_data(memWriteData),
	              .clk,
	              .xfer_size(4'd8),
	              .read_data(dmem_out));


endmodule