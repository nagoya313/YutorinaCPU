#ifndef MISA_SYMBOL_HPP_
#define MISA_SYMBOL_HPP_
#include <cstdint>
#include <boost/spirit/include/qi.hpp>
#include "insn.hpp"

const struct insn3r_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn3r_() {
    add("add", op_al | f_add)("sub", op_al | f_sub)
       ("and", op_al | f_and)("or", op_al | f_or)
       ("xor", op_al | f_xor)("nor", op_al | f_nor)
       ("sltu", op_al | f_sltu)("slt", op_al | f_slt)
       ("sll", op_al | f_sll)("slr", op_al | f_slr)("sar", op_al | f_sar);
  }
} insn3r;

const struct insn3ri_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn3ri_() {
    add("slli", op_al | f_sll)("slri", op_al | f_slr)("sari", op_al | f_sar);
  }
} insn3ri;

const struct insn2r_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn2r_() {
    add("lcr", op_ker | f_lsr)("scr", op_ker | f_ssr);
  }
} insn2r;

const struct insn1r : boost::spirit::qi::symbols<char, int> {
  insn1r() {
    add("jmpr", op_jmpr | f_jmp)("callr", op_jmpr | f_call);
  }
} insn1r;

const struct insn0r_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn0r_() {
    add("trap", op_sp | f_trap)
       ("ret", op_jmpr | f_jmp | ra(reg_ra))
       ("eret", op_ker | f_eret)("nop", nop);
  }
} insn0r;

const struct insn2ri_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn2ri_() {
    add("addis", op_addis)("addiu", op_addiu)("addui", op_addui)
       ("andi", op_andi)("ori", op_ori)("xori", op_xori)
       ("sltui", op_sltui)("slti", op_slti)
       ("beq", op_beq)("bne", op_bne);
  }
} insn2ri;

const struct insn0ri_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insn0ri_() {
    add("jmp", op_jmp)("call", op_call);
  }
} insn0ri;

const struct insnls_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  insnls_() {
    add("lw", op_lw)("lh", op_lh)("lb", op_lb)("lhu", op_lhu)("lbu", op_lbu)
       ("sw", op_sw)("sh", op_sh)("sb", op_sb);
  }
} insnls;

const struct macrob_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  macrob_() {
    add("beq", op_beq)("bne", op_bne);
  }
} macrob;

const struct macrola_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  macrola_() {
    add("la", nop);
  }
} macrola;

const struct macroli_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  macroli_() {
    add("li", op_addiu);
  }
} macroli;

const struct macrom_ : boost::spirit::qi::symbols<char, std::uint32_t> {
  macrom_() {
    add("mov", op_addiu);
  }
} macrom;

const struct gpr_ : boost::spirit::qi::symbols<char, std::uint8_t> {
  gpr_() {
    add("$zero", 0)("$at", 1)("$v0", 2)("$v1", 3)
       ("$v2", 4)("$a0", 5)("$a1", 6)("$a2", 7)
       ("$a3", 8)("$t0", 9)("$t1", 10)("$t2", 11)
       ("$t3", 12)("$t4", 13)("$t5", 14)("$t6", 15)
       ("$t7", 16)("$s0", 17)("$s1", 18)("$s2", 19)
       ("$s3", 20)("$s4", 21)("$s5", 22)("$s7", 23)
       ("$s8", 24)("$k0", 25)("$k1", 26)("$k2", 27)
       ("$fp", 28)("$sp", 29)("$gp", 30)("$ra", 31);
  }
} gpr;

#endif
