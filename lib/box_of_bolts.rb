class BoxOfBolts < Item

  def initialize
    @name = "Box of bolts"
    @weight = 25
  end

  def feed(robot)
    robot.heal!(20)
  end
end