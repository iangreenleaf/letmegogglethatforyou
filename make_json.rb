#!/bin/ruby

require 'diff'

def makeDiff(a, b)

	d = Diff.new(a, b)
	diffs = d.compactdiffs

	str = a
	curr = 0
	result = []
	puts diffs[0].join(',')
	for line in diffs[0]
		type = line[0]
		index = line[1]
		chars = line[2]
		puts 'FOOOO' + type

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

	if curr != str.length
		result << ['=', str[curr..-1]]
	end

	return result
end

puts makeDiff('abc', 'abb') == [['=', 'ab'], ['-', 'c'], ['+', 'b']]
puts makeDiff('abc def', 'abb_eef') == [['=', 'ab'], ['-', 'c d'], ['+', 'b_e'], ['=', 'ef']]
puts makeDiff('abc', 'xyz') == [['-', 'abc'], ['+', 'xyz']]
puts makeDiff('abacadae', 'bacada') == [['-', 'a'], ['=', 'bacada'], ['-', 'e']]
puts makeDiff('abacadae', 'bacada')
puts makeDiff('abc', 'abb') == [['=', 'ab'], ['-', 'c'], ['+', 'b']]


