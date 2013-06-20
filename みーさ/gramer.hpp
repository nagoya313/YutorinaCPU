#ifndef MISA_GRAMER_HPP_
#define MISA_GRAMER_HPP_
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>
#include <boost/numeric/interval.hpp>
#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>
#include "symbol.hpp"

template <typename Iterator, typename Skip>
struct as :
    boost::spirit::qi::grammar<Iterator, std::vector<std::uint32_t>(), Skip> {
	as() : as::base_type(asms) {
	  using namespace boost::spirit;
	  using boost::phoenix::bind;
		insn = insn3__ | insn3i__ | insn2__ | insn1__ | insn0__ |
		       insn2i__ | insn0i__ | insnls__ | label |
		       macrob__ | macrola__ | macroli__ | macrom__;
		asms = *insn;
		lith = ("0x" >> qi::hex)[qi::_val = qi::_1];
		lit = qi::short_ | lith;
		litl = qi::ulong_ | lith;
		lits = qi::long_ | qi::ulong_ | lith;		
		symbols = insn3r | insn3ri | insn2r | insn1r | insn0r |
		          insn2ri | insn0ri | insnls | gpr |
		          macrob | macrola | macroli | macrom;
    l_name = qi::raw[qi::alpha >> *qi::alnum];
		label = (l_name >> ':' >> '\n')[bind(&as::write_label, *this, qi::_1)];
		insn3__
		  = (qi::lexeme[insn3r] >> gpr >> ',' >> gpr >> ',' >> gpr >> '\n')
		      [bind(&as::write_insn3, *this, qi::_1, qi::_2, qi::_3, qi::_4)];
		insn3i__
		  = (qi::lexeme[insn3ri] >> gpr >> ',' >> gpr >> ',' >> lit >> '\n')
		      [bind(&as::write_insn3i, *this, qi::_1, qi::_2, qi::_3, qi::_4)];
		insn2__ = (qi::lexeme[insn2r] >> gpr >> ',' >> lit >> '\n')
		            [bind(&as::write_insn2, *this, qi::_1, qi::_2, qi::_3)];
		insn1__ = (qi::lexeme[insn1r] >> gpr >> '\n')
		            [bind(&as::write_insn1, *this, qi::_1, qi::_2)];
		insn0__ = (insn0r >> '\n')[bind(&as::write_insn0, *this, qi::_1)];
		insn2i__
		  = (qi::lexeme[insn2ri] >> gpr >> ',' >> gpr >> ',' >> lit >> '\n')
		      [bind(&as::write_insn2i, *this, qi::_1, qi::_2, qi::_3, qi::_4)];
		macrob__
		  = (qi::lexeme[macrob] >> gpr >> ',' >> gpr >> ',' >> l_name >> '\n')
		      [bind(&as::write_macrob, *this, qi::_1, qi::_2, qi::_3, qi::_4)];
		macrola__
		  = (qi::lexeme[macrola] >> gpr >> ',' >> l_name >> '\n')
		      [bind(&as::write_macrola, *this, qi::_1, qi::_2, qi::_3)];
		macroli__
		  = (qi::lexeme[macroli] >> gpr >> ',' >> lits >> '\n')
		      [bind(&as::write_macroli, *this, qi::_1, qi::_2, qi::_3)];
		macrom__ = (qi::lexeme[macrom] >> gpr >> ',' >> gpr >> '\n')
		             [bind(&as::write_macrom, *this, qi::_1, qi::_2, qi::_3)];
		insn0i__ = (qi::lexeme[insn0ri] >> litl >> '\n')
		             [bind(&as::write_insn0i, *this, qi::_1, qi::_2)];
		insnls__
		  = (qi::lexeme[insnls] >> gpr >> ',' >> lit >> '(' >> gpr >> ')' >> '\n')
		      [bind(&as::write_insnls, *this, qi::_1, qi::_2, qi::_3, qi::_4)];
	}
	
	const std::vector<std::uint32_t> &get_bin() const {
    return bin;
  }
  
  void link() {
    const boost::numeric::interval<int> short_check{
      std::numeric_limits<short>::min(), std::numeric_limits<short>::max()};
    for (const auto &p : b_link_map) {
      const auto it = label_map.find(p.first);
      if (it == label_map.end()) {
        throw std::runtime_error("リンクエラー：シンボル\"" + p.first +
                                 "\"が見つかりません。");
      } else if (boost::numeric::in(it->second - p.second, short_check)) {
        bin[p.second - 1] |= static_cast<std::uint16_t>(it->second - p.second);
      } else {
        throw std::runtime_error("リンクエラー：シンボル\"" + p.first +
                                 "\"が遠過ぎてリンク出來ません。");
      }
    }
    for (const auto &p : l_link_map) {
      const auto it = label_map.find(p.first);
      if (it == label_map.end()) {
        throw std::runtime_error("リンクエラー：シンボル\"" + p.first +
                                 "\"が見つかりません。");
      } else {
        bin[p.second - 1] |= static_cast<std::uint16_t>(it->second >> 14);
        bin[p.second - 2] |= static_cast<std::uint16_t>(it->second << 2);
      }
    }
  }

 private:
	void write_insn3(std::uint32_t insn, std::uint8_t ret,
                   std::uint8_t lhs, std::uint8_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(lhs) | rc(rhs));
  }
  
  void write_insn3i(std::uint32_t insn, std::uint8_t ret,
                    std::uint8_t lhs, std::uint8_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(lhs) | rc(rhs) | s_imm);
  }
  
  void write_insn2(std::uint32_t insn, std::uint8_t ret, std::uint8_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(rhs));
  }
  
  void write_insn1(std::uint32_t insn, std::uint8_t ret) {
	  bin.emplace_back(insn | ra(ret));
  }
  
  void write_insn0(std::uint32_t insn) {
	  bin.emplace_back(insn);
  }
  
  void write_insn2i(std::uint32_t insn, std::uint8_t ret,
                    std::uint8_t lhs, std::uint16_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(lhs) | rhs);
  }
  
  void write_macrob(std::uint32_t insn, std::uint8_t ret,
                    std::uint8_t lhs,
                    const boost::iterator_range<Iterator> &l) {
	  bin.emplace_back(insn | ra(ret) | rb(lhs));
	  b_link_map.emplace_back(std::string(l.begin(), l.end()), bin.size());
  }
  
  void write_macrola(std::uint32_t insn, std::uint8_t ret,
                     const boost::iterator_range<Iterator> &l) {
    bin.emplace_back(op_addiu | ra(ret)); 
    bin.emplace_back(op_addui | ra(ret) | rb(ret));
    l_link_map.emplace_back(std::string(l.begin(), l.end()), bin.size());
  }
  
  void write_macroli(std::uint32_t insn, std::uint8_t ret,
                     std::uint32_t rhs) {
    bin.emplace_back(insn | ra(ret) | static_cast<std::uint16_t>(rhs));
    if (rhs > std::numeric_limits<std::uint16_t>::max()) {
      bin.emplace_back(op_addui | ra(ret) | rhs >> 16);
    }
  }
  
  void write_macrom(std::uint32_t insn, std::uint8_t ret,
                    std::uint8_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(rhs));
  }
  
  void write_insn0i(std::uint32_t insn, std::uint32_t rhs) {
    if (rhs > jimm_max) {
      throw std::runtime_error("飛翔即値の値が大き過ぎます。");
    }
	  bin.emplace_back(insn | rhs);
  }
  
  void write_insnls(std::uint32_t insn, std::uint8_t ret,
                    std::int16_t lhs, std::uint8_t rhs) {
	  bin.emplace_back(insn | ra(ret) | rb(rhs) | lhs);
  }
  
  void write_label(const boost::iterator_range<Iterator> &l) {
    const std::string str(l.begin(), l.end());
    if (label_map.find(str) != label_map.end()) {
      throw std::runtime_error("エラー：ラベル\"" + str +
                               "\"が複數定義されてゐます。");
    } else {
      label_map.insert({str, bin.size()});
    }
  }
  
  boost::spirit::qi::rule<Iterator, std::vector<std::uint32_t>(), Skip> asms;
  boost::spirit::qi::rule<Iterator, Skip> insn;
	boost::spirit::qi::rule<Iterator, Skip> insnls__;
  boost::spirit::qi::rule<Iterator, Skip> insn0i__;
	boost::spirit::qi::rule<Iterator, Skip> insn2i__;
  boost::spirit::qi::rule<Iterator, Skip> insn0__;
	boost::spirit::qi::rule<Iterator, Skip> insn1__;
  boost::spirit::qi::rule<Iterator, Skip> insn2__;
	boost::spirit::qi::rule<Iterator, Skip> insn3__;
	boost::spirit::qi::rule<Iterator, Skip> insn3i__;
	boost::spirit::qi::rule<Iterator, Skip> macrob__;
	boost::spirit::qi::rule<Iterator, Skip> macrola__;
	boost::spirit::qi::rule<Iterator, Skip> macroli__;
	boost::spirit::qi::rule<Iterator, Skip> macrom__;
	boost::spirit::qi::rule<Iterator, Skip> symbols;
	boost::spirit::qi::rule<Iterator, Skip> label;
	boost::spirit::qi::rule<Iterator, std::string(), Skip> l_name;
	boost::spirit::qi::rule<Iterator, std::uint32_t(), Skip> lith;
	boost::spirit::qi::rule<Iterator, std::uint16_t(), Skip> lit;
	boost::spirit::qi::rule<Iterator, std::uint32_t(), Skip> litl;
	boost::spirit::qi::rule<Iterator, std::uint32_t(), Skip> lits;
	std::unordered_map<std::string, int> label_map;
	std::vector<std::pair<std::string, int>> b_link_map;
	std::vector<std::pair<std::string, int>> l_link_map;
	std::vector<std::uint32_t> bin;
};

#endif
