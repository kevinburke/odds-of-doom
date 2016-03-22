# Description
#   Report the odds of doom
#
# Commands:
#   hubot odds of doom - Give a report on the current odds of doom
#
# Author:
#   Kevin Burke <kev@inburke.com>
request = require 'request'

BETFAIR_URL = 'https://www.betfair.com/exchange/plus/#/politics/market/1.107373419'
BETFAIR_API_URL = 'https://www.betfair.com/www/sports/exchange/readonly/v1/bymarket\?currencyCode\=USD\&locale\=en_GB\&marketIds\=1.107373419\&rollupLimit\=25\&rollupModel\=STAKE\&types\=RUNNER_DESCRIPTION,RUNNER_STATE,RUNNER_METADATA'

getParticipants = (body) ->
  return body.eventTypes[0].eventNodes[0].marketNodes[0].runners

getName = (participant) ->
  return participant.description.runnerName

getLastPriceTraded = (participant) ->
  return participant.state.lastPriceTraded

module.exports = (robot) ->
  robot.hear /odds of doom/, (msg) ->
    request.get BETFAIR_API_URL, json: true, (err, response, body) ->
      participants = getParticipants(body)
      for participant in participants
        if getName(participant) is 'Donald Trump'
          lastPriceTraded = getLastPriceTraded(participant)
          percent = (100 / lastPriceTraded).toFixed(1)
          msg.send "Donald Trump has a #{percent}% chance of becoming the next US President, according to Betfair.com. More information: #{BETFAIR_URL}"
