function onLoad()
    self.addContextMenuItem("Record co-ordinates", itemAction)
    self.addContextMenuItem("Reveal", showItemAction)
    content = {}
end

function itemAction(color)
  local player = Player[color]
  local selected = player.getSelectedObjects()
  local success = false

  for k, v in pairs(selected) do
    if v != self then
      success = true
      table.insert(content, v)
      v.setInvisibleTo(getSeatedPlayers())
      v.setLock(true)
    end
  end

  if (success == false) then
    print("Select items to record co-ordinates for, plus the speaceship...")
  end
end

function showItemAction(color)
  log(content, "Content")

  for k, v in pairs(content) do
    print("show: ", v)
    v.setInvisibleTo({})
    v.setLock(false)
  end

  content = {}
end
