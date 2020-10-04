push = require 'libs.push'
Class = require 'libs.class'

require 'paddle'
require 'ball'

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = love.window.getDesktopDimensions() 
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH * 0.7, WINDOW_HEIGHT * 0.7
PADDLE_SPEED = 500
NET_WIDTH = 50

function love.load()
  setupScreen()
  loadPlayers()
  setupBall()
  gameState = 'start'
end

function love.keypressed(key)
  if(key == 'enter' or key == 'return') then
    if (gameState == 'start') then
      gameState = 'serve'
    else
      gameState = 'start'
    end
  end
end

function setupScreen()
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
end

function loadPlayers()
  player = Paddle(25, 25, {
    upKey = 'w',
    downKey = 's',
    isComputer = false
  })

  computer = Paddle(VIRTUAL_WIDTH - 25 - player.width, VIRTUAL_HEIGHT - 25 - player.height, {
    upKey = 'up',
    downKey = 'down',
    isComputer = true
  })
end

function setupBall()
  ball = Ball(VIRTUAL_WIDTH / 2 - (BALL_DIAMETER / 2), VIRTUAL_HEIGHT / 2 -(BALL_DIAMETER / 2))
end

function love.update(dt)
  handleKeyPress()
  checkGameState()
  updatePlayers(dt)
  updateBall(dt)
end

function checkGameState()
  if (gameState == 'serve') then
    serveBall()
    gameState = 'play'
  elseif(gameState == 'start') then
    ball:reset()
  end
end

function serveBall()
  ball:serve()
end

function updatePlayers(dt)
  player:update(dt)
  computer:update(dt)
end

function updateBall(dt)
  checkIfPlayerMissed()
  checkPaddleCollision()
  ball:update(dt)
end

function checkPaddleCollision()
  local collideWithPlayer = ball:collides(player)
  if (collideWithPlayer) then
    ball.x = player.x + player.width
    changeBallDirection()
  end

  local collideComputer = ball:collides(computer)
  if (collideComputer) then
    ball.x = computer.x - computer.width
    changeBallDirection()
  end
end

function changeBallDirection()
  ball.deltaX = -ball.deltaX * 1.10

  if ball.deltaY < 0 then
    ball.deltaY = -math.random(10, 150)
  else
    ball.deltaY = math.random(10, 150)
  end
end

function checkIfPlayerMissed()
  if (ball.x < 0) then
    ball:reset()
  elseif (ball.x > VIRTUAL_WIDTH - ball.width) then
    ball:reset()
  end
end

function handleKeyPress()
  player:move(PADDLE_SPEED, VIRTUAL_HEIGHT, ball)
  computer:move(PADDLE_SPEED, VIRTUAL_HEIGHT, ball)
end

function love.draw()
  push:start()

  love.graphics.clear(38 / 255, 38 / 255, 38 / 255, 1)
  drawNet()
  drawPlayers()
  drawBall()

  push:finish()
end

function drawNet()
  love.graphics.setColor(217 / 255, 217 / 255, 217 / 255, 1)
  love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - (NET_WIDTH / 2), 0, NET_WIDTH, VIRTUAL_HEIGHT)
end

function drawBall()
  ball:render()
end

function drawPlayers()
  player:render()
  computer:render()
end

function love.resize(w, h)
  return push:resize(w, h)
end
