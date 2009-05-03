#!/usr/bin/ruby

require 'diff'

def makeDiff(a, b)
	# For some reason we need to make copies here or Diff panics
	a = String.new(a)
	b = String.new(b)

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

def splitWords(diffArr)
	newArr = []
	for delta in diffArr
		spaceFirst = delta[1] != delta[1].lstrip
		strings = delta[1].split(' ')
		newDelta = strings.map {|s| [delta[0], ' ' + s]}
		unless spaceFirst then newDelta[0][1].strip! end
		newArr.concat newDelta
	end
	return newArr
end

def makeWords(diffArr)

	diffArr = splitWords(diffArr)

	wordQueue = []
	firstTry = ''
	secondTry = ''
	prefix = ''
	noMistakes = true
	for delta in diffArr

		type = delta[0]
		str = delta[1]

		if str != str.lstrip
			wordQueue << [prefix, firstTry, secondTry]
			noMistakes = true
			firstTry = ''
			secondTry = ''
			prefix = ''
		end

		if type == '=' && noMistakes
			prefix += str
		elsif type == '='
			firstTry += str
			secondTry += str
		elsif type == '-'
			noMistakes = false
			firstTry += str
		elsif type == '+'
			noMistakes = false
			secondTry += str
		end
	end

	wordQueue << [prefix, firstTry, secondTry]

	return wordQueue

end

#puts makeDiff('abc', 'abb') == [['=', 'ab'], ['-', 'c'], ['+', 'b']]
#puts makeDiff('abc def', 'abb_eef') == [['=', 'ab'], ['-', 'c d'], ['+', 'b_e'], ['=', 'ef']]
#puts makeDiff('abc def', 'abc xyz') == [['=', 'abc '], ['-', 'def'], ['+', 'xyz']]
#puts makeDiff('abc', 'xyz') == [['-', 'abc'], ['+', 'xyz']]
#puts makeDiff('abacadae', 'bacada') == [['-', 'a'], ['=', 'bacada'], ['-', 'e']]
#puts makeDiff('abclmnxyz', 'abklmkxyk') == [['=', 'ab'], ['-', 'c'], ['+', 'k'], ['=', 'lm'], ['-', 'n'], ['+', 'k'], ['=', 'xy'], ['-', 'z'], ['+', 'k']]

#puts JSON.generate(makeDiff('abc def', 'abb_eef'))

