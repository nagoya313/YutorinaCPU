#include <cstdint>
#include <algorithm>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>
#include "comment.hpp"
#include "gramer.hpp"

int main(int argc, char **argv) try {
  using namespace boost::spirit;
  if (argc != 3) {
    std::cerr << "入力・出力ファイル名がありません。" << std::endl;
    return -1;
  }
  std::ifstream fin(argv[1]);
  if (!fin) {
    std::cerr << "入力ファイル " << argv[1] <<
    " が開けませんでした。" << std::endl;
    return -1;
  }
  std::ofstream fout(argv[2]);
  if (!fout) {
    std::cerr << "出力ファイルが開けませんでした。" << std::endl;
    return -1;
  }
  std::string str;
  fin >> std::noskipws;
  using iterator = std::string::const_iterator;
  using siterator = std::istream_iterator<char>;
  siterator fit{fin};
  std::copy(fit, siterator(), std::back_inserter(str));
  auto it = str.cbegin();
  comment<iterator> comp;
  as<iterator, comment<iterator>> asp;
  std::vector<std::uint32_t> result;
  if (!(qi::phrase_parse(it, str.cend(), asp, comp) &&
	  it == str.cend())) {
	  std::cerr << std::count(str.cbegin(), it, '\n') + 1 << 
	  "行目：パースエラー。" << '"' <<
	  std::string(it, std::find(it, str.cend(), '\n')) << '"' << std::endl;
	} else {
  	asp.link();
	  for (const auto insn : asp.get_bin()) {
	    fout << std::hex << std::setw(8) << std::setfill('0') <<
	    insn << std::endl;
    }
  }
} catch (const std::exception &err) {
  std::cerr << err.what() << std::endl;
}
