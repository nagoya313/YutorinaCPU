#ifndef MISA_INSN_HPP_
#define MISA_INSN_HPP_
#include <cstdint>

inline constexpr std::uint32_t op(std::uint32_t o) {
  return o << 26;
}

inline constexpr std::uint32_t ra(std::uint32_t r) {
  return r << 21;
}

inline constexpr std::uint32_t rb(std::uint32_t r) {
  return r << 16;
}

inline constexpr std::uint32_t rc(std::uint32_t r) {
  return r << 11;
}

constexpr std::uint32_t op_al    = op(0x00);
constexpr std::uint32_t op_sw    = op(0x01);
constexpr std::uint32_t op_sh    = op(0x02);
constexpr std::uint32_t op_sb    = op(0x03);
constexpr std::uint32_t op_lw    = op(0x08);
constexpr std::uint32_t op_lhu   = op(0x09);
constexpr std::uint32_t op_lbu   = op(0x0a);
constexpr std::uint32_t op_lh    = op(0x0b);
constexpr std::uint32_t op_lb    = op(0x0c);
constexpr std::uint32_t op_addiu = op(0x10);
constexpr std::uint32_t op_addis = op(0x18);
constexpr std::uint32_t op_andi  = op(0x12);
constexpr std::uint32_t op_ori   = op(0x13);
constexpr std::uint32_t op_xori  = op(0x13);
constexpr std::uint32_t op_sltui = op(0x16);
constexpr std::uint32_t op_slti  = op(0x17);
constexpr std::uint32_t op_addui = op(0x30);
constexpr std::uint32_t op_beq   = op(0x20);
constexpr std::uint32_t op_bne   = op(0x28);
constexpr std::uint32_t op_jmp   = op(0x04);
constexpr std::uint32_t op_call  = op(0x05);
constexpr std::uint32_t op_jmpr  = op(0x06);
constexpr std::uint32_t op_sp    = op(0x3e);
constexpr std::uint32_t op_ker   = op(0x3f);

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

constexpr std::uint32_t nop = 0x00000000;
constexpr std::uint32_t jimm_max = 0x3fff;
constexpr std::uint32_t reg_ra = 31;

#endif
