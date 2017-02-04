fs = require 'fs'
readLine = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  counter = 0

  rl = readLine.createInterface
    input: fs.createReadStream "#{__dirname}/../data/geo.txt"

  rl.on 'line', (line) ->
    line = line.split '\t'
    if line[3] == countryCode
      counter += +line[1] - +line[0]

  rl.on 'close', () ->
    cb null, counter
