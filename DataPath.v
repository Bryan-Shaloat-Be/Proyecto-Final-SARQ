module DataPath(
input [7:0]Direccion_initial,
input clkGeneral,
output [31:0] Resultado,
output [4:0]Direccion_Guardado
);

//PC 
wire [7:0]PCsal;
//SUMADOR
wire [7:0]Direccion_Sumada;
//MEMORY INSTRUCTION
wire [31:0]Ins_initial;
//UNIDAD DE CONTROL
wire MemoryWrite_Cable;
wire MemoryReg_Cable;
wire MemoryRead_Cable;
wire Reg_Write_Cable;
wire ALU_Op1_Cable;
wire ALU_Op2_Cable;
wire ALU_Src_Cable;
wire RegDst_Cable;
wire Branch_Cable;
//BUFFER00
wire [31:0]Ins_initial_BF;
//BUFFER01
wire[31:0] Operando1_sal_cable;
wire[31:0]Operando2_sal_cable;
wire[3:0]ALU_OP_sal_cable;
//BUFFER02
wire [31:0]Resultado_buffer_Cable;
//MULTIPLEXOR00
wire [4:0]Salida_Multiplexor00;
//MULTIPLEXOR01
wire [31:0]Salida_Multiplexor01;
//MULTIPLEXOR02
wire [31:0] Dato_Save_Cable;
//MULTIPLEXOR03
wire [7:0] Direccion_NEW;
//BANCO DE REGISTROS
wire [31:0] Operador1_De_Salida;
wire [31:0] Operador2_De_Salida;
//ALU CONTROL
wire [3:0] Operacion_A_Ejecutar;
//ALU
wire Zeroflag_Cable;
wire [31:0]Resultado_Cable;

PC modulo1(
.new_d(Direccion_initial),
  .use_d(PCsal)
);

Memory_Instruction modulo2(
.add_instruc(PCsal),
.add_generate(Ins_initial)
);

sumador modulo3(
.add_llega(PCsal),
.add_sale(Direccion_Sumada)
);

Buffer000 modulo31(
.direccion_en(Ins_initial),
.reloj(clkGeneral),
.direccion_sal(Ins_initial_BF)
);

Unidad_Control modulo4(
.Controlador(Ins_initial_BF[31:26]),
.MemoryWrite(MemoryWrite_Cable),
.MemoryReg(MemoryReg_Cable),
.MemoryRead(MemoryRead_Cable),
.Reg_Write(Reg_Write_Cable),
.ALU_Op1(ALU_Op1_Cable),
.ALU_Op2(ALU_Op2_Cable), 
.ALU_Src(ALU_Src_Cable),
.RegDst(RegDst_Cable),
.Branch(ALU_Src_Cable)
);

Multiplexor_Register modulo5(
.Activador00(RegDst_Cable),
.instruction_15to11(Ins_initial_BF[15:11]),
.instruction_20to16(Ins_initial_BF[20:16]),
.intruccion_de_guardado(Salida_Multiplexor00)
);

Banco_Registros modulo6(
.Dir_Ope1(Ins_initial_BF[25:21]),
.Dir_Ope2(Ins_initial_BF[20:16]),
.Dir_Reg(Salida_Multiplexor00),
.Data_Save(Dato_Save_Cable),
.En_Write(Reg_Write_Cable),
.Operador1(Operador1_De_Salida),
.Operador2(Operador2_De_Salida)
);

Buffer01 modulo6_5(
.Operando1_en(Operador1_De_Salida),
.Operando2_en(Operador2_De_Salida),
.ALU_OP_en({2'b00,ALU_Op2_Cable,ALU_Op1_Cable}),
.clk(clkGeneral),
.Operando1_sal(Operando1_sal_cable),
.Operando2_sal(Operando2_sal_cable),
.ALU_OP_sal(ALU_OP_sal_cable)
);

ALU_Control modulo7(
.Instruction(Ins_initial_BF[5:0]),
.ALU_OP(ALU_OP_sal_cable),
.Instruction_Exe(Operacion_A_Ejecutar)
);

Multiplexor_ALU modulo8(
.Activador01(ALU_Src_Cable),
.Read_Data(Operador2_De_Salida),
.sign_extend(),
.Salida(Salida_Multiplexor01)
);

ALU modulo9(
.Operator1(Operando1_sal_cable),
.Operator2(Operando2_sal_cable),
.ALU_Operation(Operacion_A_Ejecutar),
.ZeroFlag(Zeroflag_Cable),
.ALU_Result(Resultado_Cable)
);

Buffer02 modulo9_5(
.Resultado_ALU_en(Resultado_Cable),
.clk(clkGeneral),
.Resultado_ALU_sal(Resultado_buffer_Cable)
);
Multiplexor_to_Memory_Reg modulo10(
.Activador02(MemoryReg_Cable),
.ALU_Result(Resultado_buffer_Cable),
.Read_Data(),
.Write_Data(Dato_Save_Cable)
);

//AND
wire AND;
assign AND = Zeroflag_Cable & Branch_Cable;

Multiplexor_Sumador modulo11(
.Direccion_R(Direccion_Sumada),
.Direccion_LW(),
.Activador03(AND),
.Direccion_new(Direccion_NEW)
);

assign Resultado = Resultado_buffer_Cable;
assign Direccion_Guardado = Salida_Multiplexor00;

endmodule
