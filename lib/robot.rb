class DeadRobotError < StandardError; end
class NotEnemyError < StandardError; end

class Robot

  attr_accessor :equipped_weapon
  attr_reader :position, :items, :health

  def initialize
    @position = [0,0]
    @items = []
    @health = 100
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def pick_up(object)
    if object.is_a?(BoxOfBolts) && health <= 80
      object.feed(self)
    elsif items_weight + object.weight <= 250
      @equipped_weapon = object if object.class.superclass == Weapon
      @items << object
    end
  end

  def items_weight
    return 0 if @items.length == 0
    @items.inject(0) { | sum, item | sum + item.weight }
  end

  def wound(damage)
    health - damage < 0 ? @health = 0 : @health -= damage
  end

  def heal(recover)
    health + recover > 100 ? @health = 100 : @health += recover
  end

  def heal!(recover)
    raise DeadRobotError unless health > 0
    heal(recover)
  end

  def attack(enemy)
    if check_enemy_position(enemy) == false
      raise NotEnemyError unless enemy.is_a? Robot
      equipped_weapon.nil? ? enemy.wound(5) : equipped_weapon.hit(enemy)
      @equipped_weapon = nil if equipped_weapon.is_a?(Grenade)
    end
  end

  # def attack!(enemy)
  #   if check_enemy_position(enemy) == false
  #     raise NotEnemyError unless enemy.is_a? Robot
  #     attack(enemy)
  #   end
  # end

  def check_enemy_position(enemy)
    if equipped_weapon.is_a? Grenade
      (position[0] - enemy.position[0]).abs > 2 || (position[1] - enemy.position[1]).abs > 2
    else
      (position[0] - enemy.position[0]).abs > 1 || (position[1] - enemy.position[1]).abs > 1
    end
  end


end
