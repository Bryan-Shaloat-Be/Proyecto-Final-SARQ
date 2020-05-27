module DataPath(
input [31:0]Direccion_initial,
input clkGeneral,
output [31:0] Resultado,
output [4:0]Direccion_Guardado
);

//Data Memory
wire [31:0]Salida_DM;
//PC 
wire [31:0]PCsal;
//SUMADOR
wire [31:0]Direccion_Sumada;
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
wire [31:0]Direccion_Sumada_BF;
//Sign Extend
wire [31:0]SE_Cable;
//BUFFER01
wire [31:0]Instruccion_sal_BF;
wire [31:0]Operando1_sal_BF;
wire [31:0]Operando2_sal_BF;
wire [3:0]ALU_OP_sal_BF;
wire [31:0] Sign_Extend_sal_BF;
wire [4:0]Inst15_11_sal_BF;
wire [4:0]Inst20_16_sal_BF;
wire [31:0]PC_Sumada_sal_BF;
wire RegDst_sal_BF;
wire ALUsrc_sal_BF;
wire ALUOp01_sal_BF;
wire ALUOp02_sal_BF;
wire Branch_sal_BF;
wire MemRead_sal_BF;
wire MemWrite_sal_BF;
wire MemtoReg_sal_BF;
wire RegWrite_sal_BF;
wire jump_sal_BF;
//BUFFER02
wire [31:0]Resultado_ALU_sal_BF2;
wire Branch_sal_BF2;
wire MemRead_sal_BF2;
wire MemWrite_sal_BF2;
wire MemtoReg_sal_BF2;
wire RegWrite_sal_BF2;
wire jump_sal_BF2;
wire [31:0]Sumador_Branch_sal_BF2;
wire [31:0]Data2_sal_BF2;
wire [4:0]WReg_sal_BF2;
wire  ZeroFlag_sa_BF2;
wire [31:0]PC_Sum_sal_BF2;
wire [27:0]JumpAdd_sal_BF2;
//Buffer03
wire RegWrite_sal_BF3;
wire MemtoReg_sal_BF3;
wire [31:0]MemRes_sal_BF3;
wire jump_sal_BF3;
wire [31:0]ALU_res_sal_BF3;
wire [4:0]WReg_sal_BF3;
//MULTIPLEXOR00
wire [4:0]Salida_Multiplexor00;
//MULTIPLEXOR01
wire [31:0]Salida_Multiplexor01;
//MULTIPLEXOR02
wire [31:0] Dato_Save_Cable;
//MULTIPLEXOR03
wire [31:0] Direccion_NEW;
//BANCO DE REGISTROS
wire [31:0] Operador1_De_Salida;
wire [31:0] Operador2_De_Salida;
//ALU CONTROL
wire [3:0] Operacion_A_Ejecutar;
//ALU
wire Zeroflag_Cable;
wire [31:0]Resultado_Cable;
//SHIFT LEFT
wire [27:0] SL_sal0;
//SHIFT LEFT02
wire [33:0] SL_sal;
//SUMADOR 02
wire [33:0] Add_02;
//Multiplexor Jump
wire [31:0] Direccion_Final;

PC modulo1(
.new_d(Direccion_initial),
.use_d(PCsal)
);

sumador modulo2(
.add_llega(PCsal),
.add_sale(Direccion_Sumada)
);

Memory_Instruction modulo3(
.add_instruc(PCsal),
.add_generate(Ins_initial)
);

Buffer00 modulo_buffer01(
.Direccion_En(Ins_initial),
.PC_sumada(Direccion_Sumada),
.clk(clkGeneral),
.Direccion_Sa(Ins_initial_BF),
.PC_sumada_Sa(Direccion_Sumada_BF)
);

Banco_Registros modulo4(
.Comprobacion(Ins_initial_BF),
.Dir_Ope1(Ins_initial_BF[25:21]),
.Dir_Ope2(Ins_initial_BF[20:16]),
.Dir_Reg(WReg_sal_BF3),
.Data_Save(Dato_Save_Cable),
.En_Write(Reg_Write_Cable),
.Operador1(Operador1_De_Salida),
.Operador2(Operador2_De_Salida)
);

Unidad_Control modulo5(
.Controlador(Ins_initial_BF[31:26]),
.MemoryWrite(MemoryWrite_Cable),
.MemoryReg(MemoryReg_Cable),
.MemoryRead(MemoryRead_Cable),
.Reg_Write(Reg_Write_Cable),
.ALU_Op1(ALU_Op1_Cable),
.ALU_Op2(ALU_Op2_Cable), 
.ALU_Src(ALU_Src_Cable),
.RegDst(RegDst_Cable),
.Branch(Branch_Cable),
.Jump(Jump_Cable)
);


Sign_Extend modulo_6(
.Entrada(Ins_initial_BF[15:0]),
.Salida(SE_Cable)
);

Buffer01 modulo_buffer02(
.Instruccion(Ins_initial_BF),
.Operando1_en(Operador1_De_Salida),
.Operando2_en(Operador2_De_Salida),
.ALU_OP_en({ALU_Op2_Cable,ALU_Op1_Cable}),
.clk(clkGeneral),
.Sign_Extend(SE_Cable),
.Inst15_11(Ins_initial_BF[15:11]),
.Inst20_16(Ins_initial_BF[20:16]),
.PC_Sumada(Direccion_Sumada_BF),
.RegDst(RegDst_Cable),
.ALUsrc(ALU_Src_Cable),
.Branch(Branch_Cable),
.MemRead(MemoryRead_Cable),
.MemWrite(MemoryWrite_Cable),
.MemtoReg(MemoryReg_Cable),
.RegWrite(Reg_Write_Cable),
.jump(Jump_Cable),
.Operando1_sal(Operando1_sal_BF),
.Operando2_sal(Operando2_sal_BF),
.ALU_OP_sal(ALU_OP_sal_BF),
.Sign_Extend_sal(Sign_Extend_sal_BF),
.Inst15_11_sal(Inst15_11_sal_BF),
.Inst20_16_sal(Inst20_16_sal_BF),
.PC_Sumada_sal(PC_Sumada_sal_BF),
.RegDst_sal(RegDst_sal_BF),
.ALUsrc_sal(ALUsrc_sal_BF),
.Branch_sal(Branch_sal_BF),
.MemRead_sal(MemRead_sal_BF),
.MemWrite_sal(MemWrite_sal_BF),
.MemtoReg_sal(MemtoReg_sal_BF),
.RegWrite_sal(RegWrite_sal_BF),
.jump_sal(jump_sal),
.Instruccion_sal(Instruccion_sal_BF)
);

Shift_Left02 modulo7(
.Dato_recorrer(Sign_Extend_sal_BF),
.Dato_recorrido(SL_sal)
);

Shift_Left modulo8_Jump(
.Dato_recorrer(Ins_initial_BF[25:0]),
.Dato_recorrido(SL_sal0)
);

Sumador_02 modulo9(
.add_SL(SL_sal),
.add_PC(PC_Sumada_sal_BF),
.add_sale(Add_02)
);

Multiplexor_Register modulo10(
.Activador00(RegDst_Cable),
.instruction_15to11(Inst15_11_sal_BF),
.instruction_20to16(Inst20_16_sal_BF),
.intruccion_de_guardado(Salida_Multiplexor00)
);

ALU_Control modulo11(
.Instruction_R(Instruccion_sal_BF[5:0]),
.Instruction_I(Instruccion_sal_BF[31:26]),
.ALU_OP(ALU_OP_sal_BF),
.Instruction_Exe(Operacion_A_Ejecutar)
);

Multiplexor_ALU modulo12(
.Activador01(ALU_Src_Cable),
.Read_Data(Operador2_De_Salida),
.sign_extend(SE_Cable),
.Salida(Salida_Multiplexor01)
);

ALU modulo13(
.Operator1(Operando1_sal_BF),
.Operator2(Salida_Multiplexor01),
.ALU_Operation(Operacion_A_Ejecutar),
.ZeroFlag(Zeroflag_Cable),
.ALU_Result(Resultado_Cable)
);

Buffer02 modulo_Buffer03(
.clk(clkGeneral),
.JumpAdd(SL_sal0),
.PC_Sum(PC_Sumada_sal_BF),
.ZeroFlag(Zeroflag_Cable),
.Resultado_ALU_en(Resultado_Cable),
.Sumador_Branch(Add_02),
.Data2(Operando2_sal_BF),
.WReg(Salida_Multiplexor00),
.MemRead(MemRead_sal_BF),
.MemWrite(MemWrite_sal_BF),
.Branch(Branch_sal_BF),
.MemtoReg(MemtoReg_sal_BF),
.RegWrite(RegWrite_sal_BF),
.jump(jump_sal),
.Resultado_ALU_sal(Resultado_ALU_sal_BF2),
.Branch_sal(Branch_sal_BF2),
.MemRead_sal(MemRead_sal_BF2),
.MemWrite_sal(MemWrite_sal_BF2),
.MemtoReg_sal(MemtoReg_sal_BF2),
.RegWrite_sal(RegWrite_sal_BF2),
.jump_sal(jump_sal_BF2),
.Sumador_Branch_sal(Sumador_Branch_sal_BF2),
.Data2_sal(Data2_sal_BF2),
.WReg_sal(WReg_sal_BF2),
.ZeroFlag_sal(ZeroFlag_sal_BF2),
.PC_Sum_sal(PC_Sum_sal_BF2),
.JumpAdd_sal(JumpAdd_sal_BF2)
);

Data_Memory modulo14(
.MemWrite(MemWrite_sal_BF2),
.MemRead(MemRead_sal_BF2),
.WriteData(Data2_sal_BF2),
.ALU_Result(Resultado_ALU_sal_BF2),
.Read_Data(Salida_DM)
);

//AND
wire AND;
assign AND = ZeroFlag_sal_BF2 & Branch_sal_BF2;

Multiplexor_Sumador modulo15(
.Direccion_R(PC_Sum_sal_BF2),
.Direccion_LW(Sumador_Branch_sal_BF2),
.Activador03(AND),
.Direccion_new(Direccion_NEW)
);

Multiplexor_Jump modulo16(
.ActivadorJ(jump_sal_BF2),
.Jump_Address({PC_Sum_sal_BF2[31:28],JumpAdd_sal_BF2}),
.R_or_Br_Address(Direccion_NEW),
.Direccion_New(Direccion_Final)
);

Buffer03 modulo_buffer04(
.reloj (clkGeneral),
.RegWrite(RegWrite_sal_BF2),
.MemtoReg(MemtoReg_sal_BF2),
.MemRes(Salida_DM),
.jump(jump_sal_BF2),
.ALU_res(Resultado_ALU_sal_BF2),
.Wreg(WReg_sal_BF2),
.RegWrite_sal(RegWrite_sal_BF3),
.MemtoReg_sal(MemtoReg_sal_BF3),
.MemRes_sal(MemRes_sal_BF3),
.jump_sal(jump_sal_BF3),
.ALU_res_sal(ALU_res_sal_BF3),
.Wreg_sal(WReg_sal_BF3)
);

Multiplexor_to_Memory_Reg modulo17(
.Activador02(MemtoReg_sal_BF3),
.ALU_Result(ALU_res_sal_BF3),
.Read_Data(MemRes_sal_BF3),
.Write_Data(Dato_Save_Cable)
);


assign Resultado = ALU_res_sal_BF3;
assign Direccion_Guardado = WReg_sal_BF3;

endmodule