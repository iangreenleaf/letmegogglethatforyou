#!/bin/ruby

require 'diff'

def makeDiff(a, b)

	d = Diff.new(a, b)
	diffs = d.compactdiffs

	str = a
	curr = 0
	result = []
	for diff in diffs
		for line in diff
			type = line[0]
			index = line[1]
			chars = line[2]

			if index > curr
				s = str[curr...index]
				result << ['=', s]
				curr = index
			end

			s = chars.map{|c| c.chr}.join
			result << [type, s]

			if type == '-'
				curr = index + chars.length
			end
		end
	end

	if curr != str.length
		result << ['=', str[curr..-1]]
	end

	return result
end

puts makeDiff('abc', 'abb') == [['=', 'ab'], ['-', 'c'], ['+', 'b']]
puts makeDiff('abc def', 'abb_eef') == [['=', 'ab'], ['-', 'c d'], ['+', 'b_e'], ['=', 'ef']]
puts makeDiff('abc def', 'abc xyz') == [['=', 'abc '], ['-', 'def'], ['+', 'xyz']]
puts makeDiff('abc', 'xyz') == [['-', 'abc'], ['+', 'xyz']]
puts makeDiff('abacadae', 'bacada') == [['-', 'a'], ['=', 'bacada'], ['-', 'e']]
puts makeDiff('abclmnxyz', 'abklmkxyk') == [['=', 'ab'], ['-', 'c'], ['+', 'k'], ['=', 'lm'], ['-', 'n'], ['+', 'k'], ['=', 'xy'], ['-', 'z'], ['+', 'k']]


