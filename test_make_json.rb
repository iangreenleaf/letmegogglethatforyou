require "make_json"
require "test/unit"


class TestSimpleNumber < Test::Unit::TestCase

	def test_simple
		assert_equal(4, 2+2)
		assert_equal(6, 6)
	end

	def test_words

		result = makeWords(makeDiff('abc', 'abc'))
		assert_equal([['abc', '', '']], result)

		result = makeWords(makeDiff('abc', 'def'))
		assert_equal([['', 'abc', 'def']], result)

		result = makeWords(makeDiff('abc', 'aec'))
		assert_equal([['a', 'bc', 'ec']], result)

		result = makeWords(makeDiff('abc', 'xbc'))
		assert_equal([['', 'abc', 'xbc']], result)

		result = makeWords(makeDiff('abc', 'abd'))
		assert_equal([['ab', 'c', 'd']], result)

		result = makeWords(makeDiff('abc def', 'abc dxf'))
		assert_equal([['abc', '', ''], [' d', 'ef', 'xf']], result)

		result = makeWords(makeDiff('abc def', 'abc xyz'))
		#assert_equal([['abc', '', ''], ['', 'def', 'xyz']], result)

		result = makeWords(makeDiff('foo bar baz', 'foo bar'))
		assert_equal([['foo', '', ''], [' bar', '', ''], ['', ' baz', '']], result)

		result = makeWords(makeDiff('foo bar', 'foo bar baz'))
		assert_equal([['foo', '', ''], [' bar', '', ''], ['', '', ' baz']], result)

		result = makeWords(makeDiff('foo bar', 'foobar'))
		assert_equal([['foo', '', ''], ['', ' bar', 'bar']], result)

		result = makeWords(makeDiff('foobar', 'foo bar'))
		assert_equal([['foo', '', ''], ['', 'bar', ' bar']], result)

	end

	def test_regressions

		result = makeWords(makeDiff('lunsderkov', 'lunderskov'))
		assert_equal([['lun', 'sderkov', 'derskov']], result)

		result = makeWords(makeDiff('foo bar baz bazzle boz', 'foo ber baz dazie boz'))
		#assert_equal([['foo', '', ''], [' b', 'ar', 'er'], [' baz', '', ''], [' ', 'bazzle', 'dazie'], [' boz', '', '']], result)

		result = makeWords(makeDiff('foo bxazr bazzle', 'foo bxar barzle'))
		assert_equal([['foo', '', ''], [' bxa', 'zr', 'r'], [' ba', 'zzle', 'rzle']], result)

	end

	def test_difference_detection

		result = makeWordDiff('Here is a sentence and stuff', 'Now something very different with a few similar letters')
		assert_equal([['', 'Here is a sentence and stuff', 'Now something very different with a few similar letters']], result)

	end

end

