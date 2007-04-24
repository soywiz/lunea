﻿module gameboy.tables;

import gameboy.common;

// 1 -> 4 cycles, 2 -> 8 cycles, 3 -> 12 cycles, 4 -> 16 cycles
static ubyte opcycles[0x100] = [
	//////////////////////////////////////////////////////////
	/*  00  */ 1, 3, 2, 2, 1, 1, 2, 1, 5, 2, 2, 2, 1, 1, 2, 1,
	/*  10  */ 1, 3, 2, 2, 1, 1, 2, 1, 2, 2, 2, 2, 1, 1, 2, 1,
	/*  20  */ 2, 3, 2, 2, 1, 1, 2, 1, 2, 2, 2, 2, 1, 1, 2, 1,
	/*  30  */ 2, 3, 2, 2, 3, 3, 3, 1, 2, 2, 2, 2, 1, 1, 2, 1,
	/*  40  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  50  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  60  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  70  */ 2, 2, 2, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  80  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  90  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  A0  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  B0  */ 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	/*  C0  */ 2, 3, 3, 4, 3, 4, 2, 4, 2, 4, 3, 2, 3, 6, 2, 4,
	/*  D0  */ 2, 3, 3, 3, 3, 4, 2, 4, 2, 4, 3, 0, 3, 0, 2, 4,
	/*  E0  */ 3, 3, 2, 0, 0, 4, 2, 4, 4, 1, 4, 0, 0, 0, 2, 4,
	/*  F0  */ 2, 3, 2, 1, 0, 4, 2, 4, 2, 2, 4, 1, 0, 0, 2, 4,
	//////////////////////////////////////////////////////////
];

// 1 -> 4 cycles, 2 -> 8 cycles, 3 -> 12 cycles, 4 -> 16 cycles
static ubyte opcycles_cb[0x100] = [
	////////+//////////////////////////+////////////////////////
	////////+/           00            +           08          /
	////////+//////////////////////////+////////////////////////
	/*  00  */ 2, 2, 2, 2, 2, 2, 4, 2,   2, 2, 2, 2, 2, 2, 4, 2,
	/*  10  */ 2, 2, 2, 2, 2, 2, 4, 2,   2, 2, 2, 2, 2, 2, 4, 2,
	/*  20  */ 2, 2, 2, 2, 2, 2, 4, 2,   2, 2, 2, 2, 2, 2, 4, 2,
	/*  30  */ 2, 2, 2, 2, 2, 2, 4, 2,   2, 2, 2, 2, 2, 2, 4, 2,
	/*  40  */ 2, 2, 2, 2, 2, 2, 3, 2,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  50  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  60  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  70  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  80  */ 2, 2, 2, 2, 2, 2, 4, 2,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  90  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  A0  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  B0  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  C0  */ 2, 2, 2, 2, 2, 2, 4, 2,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  D0  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  E0  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	/*  F0  */ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	////////////////////////////////////////////////////////////
];

static ubyte opargs[0x100] = [
	//////////////////////////////////////////////////////////
	/*  00  */ 0, 2, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0, 1, 0,
	/*  10  */ 0, 2, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0,
	/*  20  */ 1, 2, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0,
	/*  30  */ 1, 2, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0,
	/*  40  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  50  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  60  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  70  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  80  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  90  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  A0  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  B0  */ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	/*  C0  */ 0, 0, 2, 2, 2, 0, 1, 0, 0, 0, 2, 0, 2, 2, 1, 0,
	/*  D0  */ 0, 0, 2, 0, 2, 0, 1, 0, 0, 0, 2, 0, 2, 0, 1, 0,
	/*  E0  */ 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 2, 0, 0, 0, 1, 0,
	/*  F0  */ 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 2, 0, 0, 0, 1, 0,
	//////////////////////////////////////////////////////////
];

// # -> unsigned | * -> signed
static char[] opdisasm[0x100] = [
	//////////+/////////////////+//////////////+///////////////+//////////////+//////////////+//////////////+///////////////+//////////////+//////////////+//////////////+///////////////+////////////+/////////////+////////////+///////////////+/////////////
	//////////+        00       +      01      +       02      +      03      +      04      +      05      +       06      +      07      +      08      +      09      +      0A       +     0B     +     0C      +     0D     +      0E       +     0F    //
	//////////+/////////////////+//////////////+///////////////+//////////////+//////////////+//////////////+///////////////+//////////////+//////////////+//////////////+///////////////+////////////+/////////////+////////////+///////////////+/////////////
	/*   00   */   "NOP"        , "LD BC, #"   , "LD (BC), A"  , "INC BC"     , "INC B"      , "DEC B"      , "LD B, #"     , "RLC A"      , "LD #, SP"   , "ADD HL, BC" , "LD A, (BC)"  , "DEC BC"   , "INC C"     , "DEC C"    , "LD C, #"     , "RRC A"    ,
	/*   10   */   "STOP"       , "LD DE, #"   , "LD (DE), A"  , "INC DE"     , "INC D"      , "DEC D"      , "LD D, #"     , "RLA"        , "JR *"       , "ADD HL, DE" , "LD A, (DE)"  , "DEC DE"   , "INC E"     , "DEC E"    , "LD E, #"     , "RRA"      ,
	/*   20   */   "JR NZ, *"   , "LD HL, #"   , "LDI (HL), A" , "INC HL"     , "INC H"      , "DEC H"      , "LD H, #"     , "DAA"        , "JR Z, *"    , "ADD HL, HL" , "LDI A, (HL)" , "DEC HL"   , "INC L"     , "DEC L"    , "LD L, #"     , "CPL"      ,
	/*   30   */   "JR NC, *"   , "LD SP, #"   , "LDD (HL), A" , "INC SP"     , "INC (HL)"   , "DEC (HL)"   , "LD (HL), #"  , "SCF"        , "JR C, *"    , "ADD HL, SP" , "LDD A, (HL)" , "DEC SP"   , "INC A"     , "DEC A"    , "LD A, #"     , "CCF"      ,
	/*   40   */   "LD B, B"    , "LD B, C"    , "LD B, D"     , "LD B, E"    , "LD B, H"    , "LD B, L"    , "LD B, (HL)"  , "LD B, A"    , "LD C, B"    , "LD C, C"    , "LD C, D"     , "LD C, E"  , "LD C, H"   , "LD C, L"  , "LD C, (HL)"  , "LD C, A"  ,
	/*   50   */   "LD D, B"    , "LD D, C"    , "LD D, D"     , "LD D, E"    , "LD D, H"    , "LD D, L"    , "LD D, (HL)"  , "LD D, A"    , "LD E, B"    , "LD E, C"    , "LD E, D"     , "LD E, E"  , "LD E, H"   , "LD E, L"  , "LD E, (HL)"  , "LD E, A"  ,
	/*   60   */   "LD H, B"    , "LD H, C"    , "LD H, D"     , "LD H, E"    , "LD H, H"    , "LD H, L"    , "LD H, (HL)"  , "LD H, A"    , "LD L, B"    , "LD L, C"    , "LD L, D"     , "LD L, E"  , "LD L, H"   , "LD L, L"  , "LD L, (HL)"  , "LD L, A"  ,
	/*   70   */   "LD (HL), B" , "LD (HL), C" , "LD (HL), D"  , "LD (HL), E" , "LD (HL), H" , "LD (HL), L" , "HALT"        , "LD (HL), A" , "LD A, B"    , "LD A, C"    , "LD A, D"     , "LD A, E"  , "LD A, H"   , "LD A, L"  , "LD A, (HL)"  , "LD A, A"  ,
	/*   80   */   "ADD A, B"   , "ADD A, C"   , "ADD A, D"    , "ADD A, E"   , "ADD A, H"   , "ADD A, L"   , "ADD A, (HL)" , "ADD A, A"   , "ADC A, B"   , "ADC A, C"   , "ADC A, D"    , "ADC A, E" , "ADC A, H"  , "ADC A, L" , "ADC A, (HL)" , "ADC A, A" ,
	/*   90   */   "SUB A, B"   , "SUB A, C"   , "SUB A, D"    , "SUB A, E"   , "SUB A, H"   , "SUB A, L"   , "SUB A, (HL)" , "SUB A, A"   , "SBC A, B"   , "SBC A, C"   , "SBC A, D"    , "SBC A, E" , "SBC A, H"  , "SBC A, L" , "SBC A, (HL)" , "SBC A, A" ,
	/*   A0   */   "AND B"      , "AND C"      , "AND D"       , "AND E"      , "AND H"      , "AND L"      , "AND (HL)"    , "AND A"      , "XOR B"      , "XOR C"      , "XOR D"       , "XOR E"    , "XOR H"     , "XOR L"    , "XOR (HL)"    , "XOR A"    ,
	/*   B0   */   "OR B"       , "OR C"       , "OR D"        , "OR E"       , "OR H"       , "OR L"       , "OR (HL)"     , "OR A"       , "CP B"       , "CP C"       , "CP D"        , "CP E"     , "CP H"      , "CP L"     , "CP (HL)"     , "CP A"     ,
	/*   C0   */   "RET NZ"     , "POP BC"     , "JP NZ, #"    , "JP #"       , "CALL NZ, #" , "PUSH BC"    , "ADD A, #"    , "RST 00H"    , "RET Z"      , "RET"        , "JP Z, #"     , "CB"       , "CALL Z, #" , "CALL #"   , "ADC A, #"    , "RST 08H"  ,
	/*   D0   */   "RET NC"     , "POP DE"     , "JP NC, #"    , "-"          , "CALL NC, #" , "PUSH DE"    , "SUB #"       , "RST 10H"    , "RET C"      , "RETI"       , "JP C, #"     , "-"        , "CALL C, #" , "-"        , "SBC A, #"    , "RST 18H"  ,
	/*   E0   */   "LDH (#), A" , "POP HL"     , "LDH (C), A"  , "-"          , "-"          , "PUSH HL"    , "AND #"       , "RST 20H"    , "ADD SP, #"  , "JP HL"      , "LD (#), A"   , "-"        , "-",        , "-"        , "XOR #"       , "RST 28H"  ,
	/*   F0   */   "LDH A, (#)" , "POP AF"     , "-"           , "DI"         , "-"          , "PUSH AF"    , "OR #"        , "RST 30H"    , "LDHL SP, #" , "LD SP, HL"  , "LD A, (#)"   , "EI"       , "-"         , "-"        , "CP #"        , "RST 38H"  ,
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
];

static char[] opdisasm_cb_regs[] = ["B", "C", "D", "E", "H", "L", "(HL)", "A"];

static char[] opdisasm_cb[] = [
	////////+/////////+//////////
	////////+   00    +   08   //
	////////+/////////+//////////
	/*  00  */ "RLC"  ,  "RRC"  ,
	/*  10  */ "RL"   ,  "RR"   ,
	/*  20  */ "SLA"  ,  "SRA"  ,
	/*  30  */ "SWAP" ,  "SRL"  ,
	/*  40  */ "BIT"  ,  "-"    ,
	/*  50  */ "-"    ,  "-"    ,
	/*  60  */ "-"    ,  "-"    ,
	/*  70  */ "-"    ,  "-"    ,
	/*  80  */ "RES"  ,  "-"    ,
	/*  90  */ "-"    ,  "-"    ,
	/*  A0  */ "-"    ,  "-"    ,
	/*  B0  */ "-"    ,  "-"    ,
	/*  C0  */ "SET"  ,  "-"    ,
	/*  D0  */ "-"    ,  "-"    ,
	/*  E0  */ "-"    ,  "-"    ,
	/*  F0  */ "-"    ,  "-"    ,
	/////////////////////////////
];