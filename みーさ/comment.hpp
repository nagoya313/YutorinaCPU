#ifndef MISA_COMMENT_HPP_
#define MISA_COMMENT_HPP_
#include <boost/spirit/include/qi.hpp>

template <typename Iterator>
struct comment : boost::spirit::qi::grammar<Iterator> {
	comment() : comment::base_type(com) {
	  using namespace boost::spirit;
	  com = (qi::space - '\n') | ('#' >> *(qi::char_ - '\n') >> '\n');
	}

 private:
	boost::spirit::qi::rule<Iterator> com;
};

#endif
