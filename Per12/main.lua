function tentukanLokasiBiruSecaraAcak()
  --Lebar Layar =800 pixels
  --titik tengan layar = 800/2 => x= 400
  --panjang papan = 600 pixels, 300 = pixels di kiri titik tengah, 300 pixels di kanan titik tengah
  -- posisi kotak biru di sebelah kiri titik tengah
  -- di pixel keberapakah titik titik di sebelah kiri titik tengah?
  -- 100 <= x <= 400 
  -- 30 , 60, 90, 120 ..... (tidak per 1 pixel tetapi per 30 pixel == 0.5m)
  jumlahTik = 300/30 -- 10 tik untuk 300 pixels panjang papan di kiri
  randomTik = math.random(1, jumlahTik-1)
  --randomX = math.random(100,400) -- dari angka 100 bisa di acak bebas 100-400
  randomX = randomTik * 30 + 100
  end

function love.load()
    love.physics.setMeter(60) -- Mengatur skala dunia fisik
    world = love.physics.newWorld(0, 9.81*60, true) -- Membuat dunia fisik dengan gravitasi

    objects = {} -- Tabel untuk menyimpan objek fisik

    -- Memuat gambar papan jungkat-jungkit
    seesawImage = love.graphics.newImage("seesaw.png")

    -- Mengatur seed dengan waktu saat ini
    math.randomseed(os.time())

    -- Menghasilkan lokasi acak untuk kotak pertama
    
    local screenWidth = love.graphics.getWidth()
    local seesawWidthInMeter = 300/60
    --local randomX = 400 - math.random(1, 4) * 60


    -- Membuat kotak pertama
    objects.box1 = {}
    
    objects.box1.body = love.physics.newBody(world, 460, 250, "static")
    --objects.box1.body = love.physics.newBody(world, randomX, 90, "dynamic")
    objects.box1.shape = love.physics.newRectangleShape(60, 60)
    objects.box1.fixture = love.physics.newFixture(objects.box1.body, objects.box1.shape, 1)

    -- Membuat kotak kedua
    objects.box2 = {}
    --objects.box2.body = love.physics.newBody(world, 280, 90, "dynamic")
    tentukanLokasiBiruSecaraAcak()
    objects.box2.body = love.physics.newBody(world, randomX, 250, "static")
    objects.box2.shape = love.physics.newRectangleShape(60, 60)
    objects.box2.fixture = love.physics.newFixture(objects.box2.body, objects.box2.shape, 1)

    -- Membuat papan jungkat-jungkit
    objects.seesaw = {}
    objects.seesaw.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
    objects.seesaw.shape = love.physics.newRectangleShape(600, 20)
    objects.seesaw.fixture = love.physics.newFixture(objects.seesaw.body, objects.seesaw.shape, 1)
    objects.seesaw.body:setMass(10) -- Mengatur massa papan jungkat-jungkit

    -- Membuat titik pivot untuk papan jungkat-jungkit
    objects.pivot = {}
    objects.pivot.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "static")
    objects.pivot.shape = love.physics.newRectangleShape(10, 10)
    objects.pivot.fixture = love.physics.newFixture(objects.pivot.body, objects.pivot.shape)

    -- Membuat joint untuk menghubungkan papan dengan pivot
    objects.joint = love.physics.newRevoluteJoint(objects.pivot.body, objects.seesaw.body, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, false)

    -- Membuat tanah
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() - 50, "static")
    objects.ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
end

function love.update(dt)
    world:update(dt)
    if love.keyboard.isDown("space") then
        objects.box1.body:setType("dynamic") -- Mengubah menjadi dynamic
        objects.box2.body:setType("dynamic")
    end
end

function love.keypressed(key)
    if key == "right" then
        local old_x = objects.box1.body:getX()
        local new_x = old_x + 30 -- 30 pixel = 0.5 meter
        objects.box1.body:setX(new_x)
    end
    if key == "left" then
        local old_x = objects.box1.body:getX()
        local new_x = old_x - 30 -- 30 pixel = 0.5 meter
        objects.box1.body:setX(new_x)
    end
end

function love.draw()
    love.graphics.setColor(0.76, 0.18, 0.05) -- Warna merah untuk kotak 1
    love.graphics.polygon("fill", objects.box1.body:getWorldPoints(objects.box1.shape:getPoints()))
    love.graphics.setColor(0.25, 0.25, 1) -- Warna biru untuk kotak 2
    love.graphics.polygon("fill", objects.box2.body:getWorldPoints(objects.box2.shape:getPoints()))

    love.graphics.setColor(1, 1, 1) -- Warna putih untuk gambar papan jungkat-jungkit
    love.graphics.draw(seesawImage, objects.seesaw.body:getX(), objects.seesaw.body:getY(), objects.seesaw.body:getAngle(), 1, 1, seesawImage:getWidth() / 2, seesawImage:getHeight() / 2)

-- Menggambar garis-garis penanda jarak pada papan jungkat-jungkit
  local seesawX, seesawY = objects.seesaw.body:getPosition()
    local seesawAngle = objects.seesaw.body:getAngle()
    love.graphics.setColor(0, 0, 0) -- Warna hitam untuk garis
    for i = -5, 5 do
        local offsetX = i * 60
        local lineStartX = seesawX + offsetX * math.cos(seesawAngle) - 10 * math.sin(seesawAngle)
        local lineStartY = seesawY + offsetX * math.sin(seesawAngle) + 10 * math.cos(seesawAngle)
        local lineEndX = seesawX + offsetX * math.cos(seesawAngle) + 10 * math.sin(seesawAngle)
        local lineEndY = seesawY + offsetX * math.sin(seesawAngle) - 10 * math.cos(seesawAngle)
        love.graphics.line(lineStartX, lineStartY, lineEndX, lineEndY)
    end

    love.graphics.setColor(0.28, 0.63, 0.05) -- Warna hijau untuk tanah
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

    love.graphics.setColor(0.5, 0.5, 0.5) -- Warna abu-abu untuk pivot
    love.graphics.polygon("fill", objects.pivot.body:getWorldPoints(objects.pivot.shape:getPoints()))
end
