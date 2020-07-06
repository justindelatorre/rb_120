=begin
https://launchschool.com/exercises/1fcae291
=end

class CircularQueue
  def initialize(size)
    @size = size
    @arr = Array.new(size)
  end

  def enqueue(obj)
    @arr.unshift
    @arr.push(obj)    
  end

  def dequeue

  end

  def arr
    @arr
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

p queue.arr
queue.enqueue(1)
p queue.arr
queue.enqueue(2)
p queue.arr
puts queue.dequeue == 1
p queue.arr

queue.enqueue(3)
p queue.arr
queue.enqueue(4)
p queue.arr
puts queue.dequeue == 2

#queue.enqueue(5)
#queue.enqueue(6)
#queue.enqueue(7)
#puts queue.dequeue == 5
#puts queue.dequeue == 6
#puts queue.dequeue == 7
#puts queue.dequeue == nil

=begin
queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
=end
