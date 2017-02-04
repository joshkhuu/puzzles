assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count 1 empty line', (done) ->
    input = ''
    expected = words: 0, lines: 1, characters: 0, bytes: 0
    helper input, expected, done

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, bytes: 8
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 16, bytes: 32
    helper input, expected, done

  it 'should count words with A-Z, a-z and 0-9 only', (done) ->
    input = 'this #is a basic test!'
    expected = words: 3, lines: 1, characters: 10, bytes: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 14, bytes: 28
    helper input, expected, done

  it 'should count camelCases', (done) ->
    input = 'camelCasesWillOutputSixWords'
    expected = words: 6, lines: 1, characters: 28, bytes: 56
    helper input, expected, done

  it 'should count quoted characters, single word and camelCases', (done) ->
    input = '"this is one word!"\nsome word "Problem" withThisOneToo\n '
    expected = words: 8, lines: 3, characters: 43, bytes: 86
    helper input, expected, done

  it 'should count empty lines', (done) ->
    input = '"this is one word!"\nsome word "Problem" withThisOneToo\n\n\n'
    expected = words: 8, lines: 5, characters: 43, bytes: 86
    helper input, expected, done

  it 'should not count whitespace from start and end', (done) ->
    input = ' this is one word '
    expected = words: 4, lines: 1, characters: 13, bytes: 26
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
