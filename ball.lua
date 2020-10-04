Ball = Class{}

BALL_DIAMETER = 25

function Ball:init(x, y)
  self.x = x
  self.y = y
  self.startingX = x
  self.startingY = y
  self.width = BALL_DIAMETER
  self.height = BALL_DIAMETER
  self.deltaX = 0
  self.deltaY = 0
  self.isMoving = false
end

function Ball:reset()
  self.x = self.startingX
  self.y = self.startingY
  self.isMoving = false
end

function Ball:serve()
  self.deltaX = ((math.random(-1, 1) < 0) and -1 or 1) * math.random(300, 500)
  self.deltaY = math.random(-500, 500)
  self.isMoving = true
end

function Ball:collides(paddle)
  if (self.x > paddle.x + paddle.width or paddle.x > self.x + self.width) then
    return false
  end
  if (self.y > paddle.y + paddle.height or paddle.y > self.y + self.height) then
    return false
  end

  return true
end

function Ball:checkScreenCollision()
  if (self.y < 0) then
    self.y = 0
    self.deltaY = -self.deltaY
  elseif (self.y > VIRTUAL_HEIGHT - self.height) then
    self.y = VIRTUAL_HEIGHT - self.height
    self.deltaY = -self.deltaY
  end
end

function Ball:update(dt)
  if (self.isMoving) then
    self:checkScreenCollision()
    self.x = self.x + self.deltaX * dt
    self.y = self.y + self.deltaY * dt
  end
end

function Ball:render()
  love.graphics.setColor(242 / 255, 242 / 255, 242 / 255, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
