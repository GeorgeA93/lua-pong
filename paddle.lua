Paddle = Class{}

PADDLE_WIDTH = 25
PADDLE_HEIGHT = 100

function Paddle:init(x, y, controlTable)
  self.x = x
  self.y = y
  self.width = PADDLE_WIDTH
  self.height = PADDLE_HEIGHT
  self.deltaY = 0

  self.upKey = controlTable.upKey
  self.downKey = controlTable.downKey
  self.isComputer = controlTable.isComputer
end

function Paddle:move(paddleSpeed, screenHeight, ball)
  if (self.isComputer) then
    self:updateComputer(paddleSpeed, screenHeight, ball)
    return
  end

  if (love.keyboard.isDown(self.upKey) and self.y > 0) then
    self.deltaY = -paddleSpeed
  elseif (love.keyboard.isDown(self.downKey) and self.y < screenHeight - self.height) then
    self.deltaY = paddleSpeed
  else 
    self.deltaY = 0
  end
end

function Paddle:updateComputer(paddleSpeed, screenHeight, ball)
  local halfHeight = self.height / 2
  local paddlePos = math.floor(self.y)

  local ballPos = screenHeight / 2
  if (math.floor(ball.x) >= VIRTUAL_WIDTH * 0.4 and ball.deltaX > 0) then
    ballPos = math.floor((ball.y + (ball.height / 2)) - halfHeight)
  end

  if (ballPos > paddlePos + halfHeight) then
    self.deltaY = paddleSpeed
  elseif (ballPos < paddlePos - halfHeight) then
    self.deltaY = -paddleSpeed
  else
    self.deltaY = 0
  end
end

function Paddle:update(dt)
  self.y = self.y + self.deltaY * dt
end

function Paddle:render()
  love.graphics.setColor(242 / 255, 242 / 255, 242 / 255, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
