####################################################
# ** Main
####################################################

require "mkrpg/engine" # 1. Loads Classes
$game = Game.load_dir(Dir.pwd) # 2. Load Game
$game.play # 3. Runs Game