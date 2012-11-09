require 'argus'

drone = Argus::Drone.new
drone.start

drone.take_off
sleep 5
drone.turn_right(1.0)
sleep 5
drone.turn_left(1.0)
sleep 5
drone.hover.land
sleep 5
drone.stop
