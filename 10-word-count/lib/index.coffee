through2 = require 'through2'

###
Words: words containing non-alphanumeric characters are not included
Lines: include empty lines
Characters: exclude double quotes and spaces in count.
Bytes: default to 2 bytes per character for UTF-8
###

module.exports = ->
  words = 0
  lines = 1
  characters = 0
  bytes = 0

  transform = (chunk, encoding, cb) ->

    # Count lines
    lines = chunk.split(/\r\n|\r|\n/g).length

    # Change to one line
    chunk = chunk.replace(/\r\n|\r|\n/g, '')

    # Quote words
    if chunk.match(/"+/g)

      # Count quote words
      words += chunk.match(/"([^"]+)"/g).length

      chunk.match(/"([^"]+)"/g).map((item) ->
        characters += item.replace(/["|\s]/g, '').length
      )

      # replace quote words
      chunk = chunk.replace(/"([^"]+)"/g, "")

    # clean up spaces, space in front of capital letter, and trim leading whitespace
    chunk = chunk.replace(/  +/g, ' ').replace(/([A-Z])/g, ' $1').trim().split(' ')

    # filter out any further empty values words and words with non-alphanumeric characters
    chunk = chunk.filter (value) ->
      if value.length > 0
        return value.match(/^[a-z0-9]+$/i)
      return false

    # add to words count
    words += chunk.length
    characters += chunk.join('').length

    # characters x 2 = 1 char = 2 bytes for UTF-8
    bytes = characters *2

    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, bytes}
    this.push null
    return cb()

  return through2.obj transform, flush
