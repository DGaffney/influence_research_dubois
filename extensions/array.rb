class Array
  def centroid
    dimensions = self.flatten
    x_cent = (x_vals = 1.upto(dimensions.length).collect{|x| dimensions[x] if x.even?}.compact).sum/x_vals.length
    y_cent = (y_vals = 1.upto(dimensions.length).collect{|y| dimensions[y] if !y.even?}.compact).sum/y_vals.length
    return x_cent, y_cent
  end

  def area
    side_one = (self[0].to_f-self[2].to_f).abs
    side_two = (self[1].to_f-self[3].to_f).abs
    return side_one*side_two
  end

  def average
    return self.sum/self.length.to_f
  end
  
end