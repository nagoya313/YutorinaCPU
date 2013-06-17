#ifndef MISA_INSN_HPP_
#define MISA_INSN_HPP_
#include <cstdint>

constexpr std::uint32_t op_shift = 26;
constexpr std::uint32_t ra_shift = 21;
constexpr std::uint32_t rb_shift = 16;
constexpr std::uint32_t rc_shift = 11;

constexpr std::uint32_t op_al    = 0x00 << op_shift;
constexpr std::uint32_t op_sw    = 0x01 << op_shift;
constexpr std::uint32_t op_sh    = 0x02 << op_shift;
constexpr std::uint32_t op_sb    = 0x03 << op_shift;
constexpr std::uint32_t op_lw    = 0x08 << op_shift;
constexpr std::uint32_t op_lhu   = 0x09 << op_shift;
constexpr std::uint32_t op_lbu   = 0x0a << op_shift;
constexpr std::uint32_t op_lh    = 0x0b << op_shift;
constexpr std::uint32_t op_lb    = 0x0c << op_shift;
constexpr std::uint32_t op_addiu = 0x10 << op_shift;
constexpr std::uint32_t op_addis = 0x18 << op_shift;
constexpr std::uint32_t op_andi  = 0x12 << op_shift;
constexpr std::uint32_t op_ori   = 0x13 << op_shift;
constexpr std::uint32_t op_xori  = 0x13 << op_shift;
constexpr std::uint32_t op_sltui = 0x16 << op_shift;
constexpr std::uint32_t op_slti  = 0x17 << op_shift;
constexpr std::uint32_t op_addui = 0x30 << op_shift;
constexpr std::uint32_t op_beq   = 0x20 << op_shift;
constexpr std::uint32_t op_bne   = 0x28 << op_shift;
constexpr std::uint32_t op_jmp   = 0x04 << op_shift;
constexpr std::uint32_t op_call  = 0x05 << op_shift;
constexpr std::uint32_t op_jmpr  = 0x06 << op_shift;
constexpr std::uint32_t op_sp    = 0x3e << op_shift;
constexpr std::uint32_t op_ker   = 0x3f << op_shift;

constexpr std::uint32_t f_add  = 0x0;
constexpr std::uint32_t f_sub  = 0x1;
constexpr std::uint32_t f_and  = 0x2;
constexpr std::uint32_t f_or   = 0x3;
constexpr std::uint32_t f_xor  = 0x4;
constexpr std::uint32_t f_nor  = 0x5;
constexpr std::uint32_t f_sltu = 0x6;
constexpr std::uint32_t f_slt  = 0x7;
constexpr std::uint32_t f_sll  = 0x8;
constexpr std::uint32_t f_slr  = 0x9;
constexpr std::uint32_t f_sar  = 0xa;
constexpr std::uint32_t f_mul  = 0xb;
constexpr std::uint32_t f_mulu = 0xc;
constexpr std::uint32_t f_div  = 0xd;
constexpr std::uint32_t f_divu = 0xe;

constexpr std::uint32_t s_imm = 0x1 << 10;

constexpr std::uint32_t f_jmp  = 0x0;
constexpr std::uint32_t f_call = 0x1;

constexpr std::uint32_t f_trap = 0x0;

constexpr std::uint32_t f_eret = 0x0;
constexpr std::uint32_t f_ssr  = 0x1;
constexpr std::uint32_t f_lsr  = 0x2;

constexpr std::uint32_t reg_ra = 31;

#endif
