--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]
--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    inches = 2.54
    rangeToolRanges = {5, 10, 15, 20, 30, 45, 60, 75, 15, 0}
    elevation = 0.2
end
--[[ The onUpdate event is called once per frame. --]]
function onUpdate ()
    --[[ print('onUpdate loop!') --]]
end
function onScriptingButtonDown(index, color)
    local player = Player[color]
    local selected = player.getSelectedObjects()
    local range = rangeToolRanges[index]
    if range == 0 then
      print(player.steam_name, " disabled highlight")
    elseif index == 9 then
      print(player.steam_name, " requested objective range highlight")
    else
      print(player.steam_name, " requested ", range, "cm highlight")
    end
    local rangeInCm = range / inches
    for k, v in pairs(selected) do
      local rotation = v.getRotation()
      local scale = v.getScale()
      local compensatedThickness = (0.05 / math.max(scale["x"], scale["x"], scale["x"]))
      -- local rotation = v.getRotation()
      -- local compensatedRotation = {-rotation["x"],0,-rotation["z"]}
      --log(scale, "Scale")
      --log(v.getBoundsNormalized()["size"], "Size")
      --log(compensatedThickness, "Thickness")
      if index == 10 then
        v.setVectorLines({})
      elseif  index == 9 then
        v.setVectorLines({
            {
                points    = circleFromCenter(v, rangeInCm),
                color     = stringColorToRGB(color),
                thickness = compensatedThickness,
                rotation  = {0, 0, 0},
            }
        })
      elseif hasRectangleBase(v) then
        v.setVectorLines({
            {
                points    = rectangleZoc(v, rangeInCm),
                color     = stringColorToRGB(color),
                thickness = compensatedThickness,
                rotation  = {0, 0, 0},
            }
        })
      else
        v.setVectorLines({
            {
                points    = circleZoc(v, rangeInCm),
                color     = stringColorToRGB(color),
                thickness = compensatedThickness,
                rotation  = {0, 0, 0},
            }
        })
      end
    end
end

function hasRectangleBase(obj)
  local size = obj.getBoundsNormalized()["size"]
  local ratio = math.abs(size[1]/size[3])
  return ratio < 0.95 or ratio > 1.05
end

function circleZoc(obj, radius)
    local size = obj.getBoundsNormalized()["size"]
    local radiusFromCenter = radius + (math.max(size[1], size[3]) / 2)
    local points = {}

    insertCircle(points, obj, radiusFromCenter, elevation)
    insertCircle(points, obj, radiusFromCenter, elevation + 1)
    return points
end

function circleFromCenter(obj, radius)
    local points = {}
    insertCircle(points, obj, radius, elevation)
    insertCircle(points, obj, radius, elevation + 1)
    return points
end

function rectangleZoc(obj, zoc)
  -- local points = {}
  -- insertRectangle(points, obj, zoc, elevation)
  -- insertRectangle(points, obj, zoc, elevation + 1)
  -- return points
  local size = obj.getBoundsNormalized()["size"]
  local width = size[1]
  local height = size[3]
  local scale = obj.getScale()
  local points = {}
  table.insert(points, globalToLocal(obj, {zoc+(width/2), elevation, -height/2}))
  for i=0,9 do
      table.insert(points, globalToLocal(obj, {(width/2) + math.cos(math.rad(i*10)) * zoc, elevation, (height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=10,18 do
      table.insert(points, globalToLocal(obj, {(-width/2) + math.cos(math.rad(i*10)) * zoc, elevation, (height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=19,27 do
      table.insert(points, globalToLocal(obj, {(-width/2) + math.cos(math.rad(i*10)) * zoc, elevation, (-height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=28,36 do
      table.insert(points, globalToLocal(obj, {(width/2) + math.cos(math.rad(i*10)) * zoc, elevation, (-height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  local compensatedElevation = elevation + 1
  for i=0,9 do
      table.insert(points, globalToLocal(obj, {(width/2) + math.cos(math.rad(i*10)) * zoc, compensatedElevation, (height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=10,18 do
      table.insert(points, globalToLocal(obj, {(-width/2) + math.cos(math.rad(i*10)) * zoc, compensatedElevation, (height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=19,27 do
      table.insert(points, globalToLocal(obj, {(-width/2) + math.cos(math.rad(i*10)) * zoc, compensatedElevation, (-height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  for i=28,36 do
      table.insert(points, globalToLocal(obj, {(width/2) + math.cos(math.rad(i*10)) * zoc, compensatedElevation, (-height/2) + math.sin(math.rad(i*10)) * zoc}))
  end
  table.insert(points, globalToLocal(obj, {(width/2) + math.cos(math.rad(0)) * zoc, compensatedElevation, (height/2) + math.sin(math.rad(0)) * zoc}))
  return points
end

function insertCircle(points, object, radius, elevation)
  for i = 0,36 do
    table.insert(points, globalToLocal(object, {
      (math.cos(math.rad(i*10)) * radius),
      elevation,
      (math.sin(math.rad(i*10)) * radius)
    }))
  end
end

function globalToLocal(object, coordinates)
  return object.positionToLocal({
    coordinates[1] + object.getPosition().x,
    coordinates[2] + object.getPosition().y,
    coordinates[3] + object.getPosition().z
  })
end