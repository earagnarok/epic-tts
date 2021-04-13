function onLoad()
    self.addContextMenuItem("Save position", savePosition)
    position = {}
    player = {}
end

function savePosition(color)
  position = self.getPosition()
  player = color
  self.clearContextMenu()
  self.addContextMenuItem("Reveal position", moveToPosition)
end

function moveToPosition(color)
  if (player == color) then
    self.setPositionSmooth(position, false, false)
    self.clearContextMenu()
    self.addContextMenuItem("Save position", savePosition)
  else
    print("Only " .. Player[color].steam_name .. " can reveal saved position!")
  end
end
