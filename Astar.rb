class Astar
	
	attr_accessor :openList
	attr_accessor :closedList
	
	attr_accessor :array
	attr_accessor :width
	attr_accessor :height

	def initialize(width, height)
		@width = width
		@height = height
		@array = Array.new(@width){Array.new(@height) {0}}
		@openList = Hash.new 
		@closedList = Hash.new
	
	end			
	
	def find_path(st, ed, wall) #what is st or end
		s_i = st[0]
		s_j = st[1]

		e_i = ed[0]
		e_j = ed[1]
                
		wall.each_index do|i|
			#puts i
			@array[wall[i][0]][wall[i][1]]="w"
		end
		
		@array[s_i][s_j]="s"
		@array[e_i][e_j]="e"

		# Start of Algorithm
		puts "Your Grid is:"
		print " #{@array} \n "
		@openList[[s_i,s_j]] = [0, 0, 0, nil, nil]
		extractList(s_i, s_j, e_i, e_j)
		list = []
		extractPath( e_i,e_j, s_i, s_j,list)
		print [e_i, e_j] << list #would this be correct or should it be list=extractPath 
	end
	


	def extractList(current_i, current_j, e_i,e_j)
		until @closedList.include?([e_i, e_j]) || @openList.empty?
			count = 0
			count1 = 0
			
			child_i= current_i-1
			child_j= current_j-1
			while ((child_i)-current_i).abs<=1 || ((child_j)-current_j).abs<=1  do
				count +=1
				if (child_i >=0 && child_j >=0) && (child_i < @height && child_j <@width)
					if (child_i != current_i || child_j != current_j) 	
						if !@openList.include?([child_i, child_j]) && !@closedList.include?([child_i, child_j]) && @array[child_i][child_j] != "w"
							hash= calc_G_H_F(child_i,child_j, current_i, current_j, e_i, e_j)
							@openList[[child_i, child_j]] = hash
						end
					end
					count1+=1
					if count1%3 != 0 
						child_j+=1
					else
						child_j = current_j-1
						child_i+=1	
					end	
				else
					if child_i < 0
						child_i+=1
						count+=1
					elsif child_j <0
						child_j +=1
						count+=1
					elsif child_j >= @width && child_i < @height-1
						child_i+=1
						child_j = current_j-1  
						count+=1 
					elsif (child_j >= @width && child_i >= @height) || (child_j >= @width && child_i == @height-1) || child_i >= @height
						break
					end
				end
				if count ==9
						break
				end
			end 
			puts "\n"
			@closedList[[current_i,current_j]] = @openList[[current_i,current_j]]
			@openList.delete([current_i,current_j])
			key = @openList.min_by{|k,v| v}
			key = key[0]
			extractList(key[0], key[1], e_i, e_j)
#			
		end
	end
	




	def calc_G_H_F(c_i,c_j, p_i,p_j, e_i,e_j)
		
		value = @openList[[p_i,p_j]]
		if (c_i-p_i).abs == 1 && (c_j-p_j).abs == 1		
			g=value[0]+14
		else
			g=value[0]+10
		end			
		h = (c_i-e_i).abs*10 + (c_j-e_j).abs*10
		f=h+g
		hash= [f, g, h, p_i, p_j]	
	end
	$list=[]
	def extractPath(cell_i, cell_j, s_i, s_j, list) #DONT use instance variable $list
		until cell_i == s_i && cell_j == s_j
			parent_values= @closedList[[cell_i, cell_j]]
			cell_i = parent_values[3]
			cell_j = parent_values[4]	
			list << [cell_i, cell_j]
			
			extractPath(cell_i, cell_j, s_i, s_j)
			cell_i = s_i
			cell_j = s_j
		end
		list #what happens if Ruby is pass by value, what about pass by reference
		#puts "list after call is : #{$list} "
	end
	
end

astar = Astar.new(15,15)

wall = [[5,5],[5,6], [7,8], [8,8], [14,3], [14,4],[14,5]]
st = [1,3]
ed = [12,13]
astar.findPath(st, ed, wall)


