chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect

describe "cc", ->
  beforeEach ->
    @robot =
      brain:
        on: sinon.spy()
      respond: sinon.spy()
      receiveMiddleware: sinon.spy (ctx, next, done) =>
        # Do nothing

    require("../src/cc")(@robot)

  it "registers a respond listener", ->
    expect(@robot.respond).to.have.been.calledWith(/cc new-channel ([a-zA-Z0-9]+) (.+)/i)
    expect(@robot.respond).to.have.been.calledWith(/cc new-global ([a-zA-Z0-9]+) (.+)/i)
    expect(@robot.respond).to.have.been.calledWith(/cc remove ([a-zA-Z0-9]+)/i)
    expect(@robot.respond).to.have.been.calledWith(/cc list/i)

  it "registers a listener middleware", ->
    expect(@robot.receiveMiddleware).to.have.been.called

  it "registers a brain event listener", ->
    expect(@robot.brain.on).to.have.been.calledWith("loaded")
