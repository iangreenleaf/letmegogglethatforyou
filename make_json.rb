#!/usr/bin/ruby

require 'diff'

def makeDiff(a, b)
	# For some reason we need to make copies here or Diff panics
	a = String.new(a.strip)
	b = String.new(b.strip)

	d = Diff.new(a, b)
	diffs = d.compactdiffs

	bcurr = 0
	acurr = 0
	result = []
	for diff in diffs
		for line in diff
			type = line[0]
			index = line[1]
			chars = line[2]

			# TODO remove this duplication
			if type == '+' and index > bcurr
				s = b[bcurr...index]
				result << ['=', s]
				acurr += s.length
				bcurr += s.length
			elsif type == '-' and index > acurr
				s = a[acurr...index]
				result << ['=', s]
				acurr += s.length
				bcurr += s.length
			end

			s = chars.map{|c| c.chr}.join
			result << [type, s]

			if type == '-'
				acurr += chars.length
			else
				bcurr += chars.length
			end
		end
	end

	if bcurr != b.length
		result << ['=', b[bcurr..-1]]
	end

	return result
end

def checkDifference(diff)

	totals = {'=' => 0, '+' => 0, '-' => 0}

	for line in diff
		totals['='] += line[0].length
		totals['-'] += line[1].length
		totals['+'] += line[2].length
	end

	unchanged = totals['=']
	changed = totals['+'] + totals['-']

	ratio = 1.0 * unchanged / ((changed / 2) + unchanged)
	return (ratio < 0.2)
end

def splitWords(diffArr)
	newArr = []
	for delta in diffArr
		spaceOnly = delta[1].strip.length == 0
		spaceFirst = delta[1] != delta[1].lstrip
		spaceLast = (( delta[1] != delta[1].rstrip ) and not spaceOnly )
		if spaceOnly
			strings = ['']
		else
			strings = delta[1].split(' ')
		end
		newDelta = strings.map {|s| [delta[0], ' ' + s]}
		unless spaceFirst then newDelta[0][1].lstrip! end
		if spaceLast then newDelta[newDelta.length-1][1] += ' ' end
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

def makeWordDiff(a, b)

	diff = makeDiff(a, b)
	diff = makeWords(diff)

	if checkDifference(diff)
		return [['', a, b]]
	else
		return diff
		return makeWords(diff)
	end

end
