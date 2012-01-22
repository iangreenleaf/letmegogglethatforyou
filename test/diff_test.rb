require "make_json"
require "test/unit"


class DiffTest < Test::Unit::TestCase

	def test_words

		result = makeWordDiff('abc', 'abc')
		assert_equal([['abc', '', '']], result)

		result = makeWordDiff('abc', 'def')
		assert_equal([['', 'abc', 'def']], result)

		result = makeWordDiff('abc', 'aec')
		assert_equal([['a', 'bc', 'ec']], result)

		result = makeWordDiff('abc', 'xbc')
		assert_equal([['', 'abc', 'xbc']], result)

		result = makeWordDiff('abc', 'abd')
		assert_equal([['ab', 'c', 'd']], result)

		result = makeWordDiff('abc def', 'abc dxf')
		assert_equal([['abc', '', ''], [' d', 'ef', 'xf']], result)

		result = makeWordDiff('abc def', 'abc xyz')
		#assert_equal([['abc', '', ''], ['', 'def', 'xyz']], result)

		result = makeWordDiff('foo bar baz', 'foo bar')
		assert_equal([['foo', '', ''], [' bar', '', ''], ['', ' baz', '']], result)

		result = makeWordDiff('foo bar', 'foo bar baz')
		assert_equal([['foo', '', ''], [' bar', '', ''], ['', '', ' baz']], result)

		result = makeWordDiff('foo bar', 'foobar')
		assert_equal([['foo', '', ''], ['', ' bar', 'bar']], result)

		result = makeWordDiff('foobar', 'foo bar')
		assert_equal([['foo', '', ''], ['', 'bar', ' bar']], result)

	end

	def test_regressions

		result = makeWordDiff('lunsderkov', 'lunderskov')
		assert_equal([['lun', 'sderkov', 'derskov']], result)

		result = makeWordDiff('foo bar baz bazzle boz', 'foo ber baz dazie boz')
		#assert_equal([['foo', '', ''], [' b', 'ar', 'er'], [' baz', '', ''], [' ', 'bazzle', 'dazie'], [' boz', '', '']], result)

		result = makeWordDiff('foo bxazr bazzle', 'foo bxar barzle')
		assert_equal([['foo', '', ''], [' bxa', 'zr', 'r'], [' ba', 'zzle', 'rzle']], result)

	end

	def test_difference_detection

		result = makeWordDiff('abc', 'aef')
		assert_equal([['a', 'bc', 'ef']], result)

		result = makeWordDiff('Here is a sentence and stuff', 'Herg ig g sentencg ang some g g g gs')
		assert_not_equal([['', 'Here is a sentence and stuff', 'Herg ig g sentencg ang some g g g gs']], result)

		result = makeWordDiff('Here is a sentence and stuff', 'Now something very different with a few similar letters')
		assert_equal([['', 'Here is a sentence and stuff', 'Now something very different with a few similar letters']], result)

	end

end
