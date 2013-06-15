#include <cstdint>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>

using namespace boost::spirit;

constexpr std::uint32_t op_shift = 26;

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
constexpr std::uint32_t f_ret  = 0x1;

constexpr std::uint32_t f_eret = 0x0;
constexpr std::uint32_t f_ssr  = 0x1;
constexpr std::uint32_t f_lsr  = 0x2;

const struct insn3r_ : qi::symbols<char, std::uint32_t> {
  insn3r_() {
    add("add", op_al | f_add)("sub", op_al | f_sub)
       ("and", op_al | f_and)("or", op_al | f_or)
       ("xor", op_al | f_xor)("nor", op_al | f_nor)
       ("sltu", op_al | f_sltu)("slt", op_al | f_slt)
       ("sll", op_al | f_sll)("slr", op_al | f_slr)("sar", op_al | f_sar);
  }
} insn3r;

const struct insn3ri_ : qi::symbols<char, std::uint32_t> {
  insn3ri_() {
    add("slli", op_al | f_sll)("slri", op_al | f_slr)("sari", op_al | f_sar);
  }
} insn3ri;

const struct insn2r_ : qi::symbols<char, std::uint32_t> {
  insn2r_() {
    add("lcr", op_ker | f_lsr)("scr", op_ker | f_ssr);
  }
} insn2r;

const struct insn1r : qi::symbols<char, int> {
  insn1r() {
    add("jmpr", op_jmpr | f_jmp)("callr", op_jmpr | f_call);
  }
} insn1r;

const struct insn0r_ : qi::symbols<char, std::uint32_t> {
  insn0r_() {
    add("trap", op_sp | f_trap)("ret", op_sp | f_ret)
       ("eret", op_ker | f_eret)("nop", 0x00000000);
  }
} insn0r;

const struct insn2ri_ : qi::symbols<char, std::uint32_t> {
  insn2ri_() {
    add("addis", op_addis)("addiu", op_addiu)("addui", op_addui)
       ("andi", op_andi)("ori", op_ori)("xori", op_xori)
       ("sltui", op_sltui)("slti", op_slti)
       ("beq", op_beq)("bne", op_bne);
  }
} insn2ri;

const struct insn0ri_ : qi::symbols<char, std::uint32_t> {
  insn0ri_() {
    add("jmp", op_jmp)("call", op_call);
  }
} insn0ri;

const struct insnls_ : qi::symbols<char, std::uint32_t> {
  insnls_() {
    add("lw", op_lw)("lh", op_lh)("lb", op_lb)("lhu", op_lhu)("lbu", op_lbu)
       ("sw", op_sw)("sh", op_sh)("sb", op_sb);
  }
} insnls;

const struct gpr_ : qi::symbols<char, std::uint8_t> {
  gpr_() {
    add("$zero", 0)("$at", 1)("$v0", 2)("$v1", 3)
       ("$v2", 4)("$a0", 5)("$a1", 6)("$a2", 7)
       ("$a3", 8)("$t0", 9)("$t1", 10)("$t2", 11)
       ("$t3", 12)("$t4", 13)("$t5", 14)("$t6", 15)
       ("$t7", 16)("$s0", 17)("$s1", 18)("$s2", 19)
       ("$s3", 20)("$s4", 21)("$s5", 22)("$s7", 23)
       ("$s8", 24)("$k0", 25)("$k1", 26)("$k2", 27)
       ("$k3", 28)("$fp", 29)("$sp", 30)("$gp", 31);
  }
} gpr;

template <typename Iterator>
struct as : qi::grammar<Iterator, std::uint32_t(), qi::space_type> {
	as() : as::base_type(insn) {
	  using boost::phoenix::bind;
		insn = insn3__ | insn2__ | insn1__ | insn0__ | insn2i__ | insn0i__ | insnls__;
		lit = qi::short_ | qi::hex;
		litl = qi::ulong_ | qi::hex;
		insn3__ = (qi::lexeme[insn3r >> " "] >> gpr >> "," >> gpr >> "," >> gpr)[qi::_val = bind(&write_insn3, qi::_1, qi::_2, qi::_3, qi::_4)];
		insn3i__ = (qi::lexeme[insn3ri >> " "] >> gpr >> "," >> gpr >> "," >> lit)[qi::_val = bind(&write_insn3i, qi::_1, qi::_2, qi::_3, qi::_4)];
		insn2__ = (qi::lexeme[insn2r >> " "] >> gpr >> "," >> lit)[qi::_val = bind(&write_insn2, qi::_1, qi::_2, qi::_3)];
		insn1__ = (qi::lexeme[insn1r >> " "] >> gpr)[qi::_val = bind(&write_insn1, qi::_1, qi::_2)];
		insn0__ = (insn0r)[qi::_val = bind(&write_insn0, qi::_1)];
		insn2i__ = (qi::lexeme[insn2ri >> " "] >> gpr >> "," >> gpr >> "," >> lit)[qi::_val = bind(&write_insn2i, qi::_1, qi::_2, qi::_3, qi::_4)];
		insn0i__ = (qi::lexeme[insn0ri >> " "] >> litl)[qi::_val = bind(&write_insn0i, qi::_1, qi::_2)];
		insnls__ = (qi::lexeme[insnls >> " "] >> gpr >> "," >> lit >> "(" >> gpr >> ")")[qi::_val = bind(&write_insnls, qi::_1, qi::_2, qi::_3, qi::_4)];
	}

 private:
	static std::uint32_t write_insn3(std::uint32_t insn, std::uint8_t ret, std::uint8_t lhs, std::uint8_t rhs) {
	  return insn | (ret << 21) | (lhs << 16) | (rhs << 11);
  }
  
  static std::uint32_t write_insn3i(std::uint32_t insn, std::uint8_t ret, std::uint8_t lhs, std::uint8_t rhs) {
	  return insn | (ret << 21) | (lhs << 16) | (rhs << 11) | s_imm;
  }
  
  static std::uint32_t write_insn2(std::uint32_t insn, std::uint8_t ret, std::uint8_t rhs) {
	  return insn | (ret << 21) | (rhs << 16);
  }
  
  static std::uint32_t write_insn1(std::uint32_t insn, std::uint8_t ret) {
	  return insn | (ret << 21);
  }
  
  static std::uint32_t write_insn0(std::uint32_t insn) {
	  return insn;
  }
  
  static std::uint32_t write_insn2i(std::uint32_t insn, std::uint8_t ret, std::uint8_t lhs, std::int16_t rhs) {
	  return insn | (ret << 21) | (lhs << 16) | static_cast<std::uint16_t>(rhs);
  }
  
  static std::uint32_t write_insn0i(std::uint32_t insn, std::int32_t rhs) {
	  return insn | rhs;
  }
  
  static std::uint32_t write_insnls(std::uint32_t insn, std::uint8_t ret, std::int16_t lhs, std::uint8_t rhs) {
	  return insn | (ret << 21) | (rhs << 16) | lhs;
  }
  
  qi::rule<Iterator, std::uint32_t(), qi::space_type> insn;
	qi::rule<Iterator, std::uint32_t(), qi::space_type> insnls__;
  qi::rule<Iterator, std::uint32_t(), qi::space_type> insn0i__;
	qi::rule<Iterator, std::uint32_t(), qi::space_type> insn2i__;
  qi::rule<Iterator, std::uint32_t(), qi::space_type> insn0__;
	qi::rule<Iterator, std::uint32_t(), qi::space_type> insn1__;
  qi::rule<Iterator, std::uint32_t(), qi::space_type> insn2__;
	qi::rule<Iterator, std::uint32_t(), qi::space_type> insn3__;
	qi::rule<Iterator, std::uint32_t(), qi::space_type> insn3i__;
	qi::rule<Iterator, std::uint16_t(), qi::space_type> lit;
	qi::rule<Iterator, std::uint16_t(), qi::space_type> litl;
};

int main(int argc, char **argv) try {
  if (argc != 3) {
    std::cerr << "入力・出力ファイル名がありません。" << std::endl;
    return -1;
  }
  std::ifstream fin(argv[1]);
  if (!fin) {
    std::cerr << "入力ファイル " << argv[1] << " が開けませんでした。" << std::endl;
    return -1;
  }
  std::ofstream fout(argv[2]);
  if (!fout) {
    std::cerr << "出力ファイルが開けませんでした。" << std::endl;
    return -1;
  }
  as<std::string::const_iterator> asp;
  std::string line;
  while (std::getline(fin, line)) {
    auto it = line.cbegin();
    std::uint32_t result;
	  if (!(qi::phrase_parse(it, line.cend(), asp, qi::space, result) && it == line.cend())) {
	    std::cerr << line << " パースエラー。" << std::endl;  
	  }
	  fout << std::hex << std::setw(8) << std::setfill('0') << result << std::endl;
  }
} catch (const std::exception &err) {
  std::cerr << err.what() << std::endl;
}
