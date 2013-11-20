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
		@openList = {}
		@closedList = {}
	
	end			
	
	def find_path(index_of_start, index_of_end, wall) #what is st or end
		start_i = index_of_start[0]
		start_j = index_of_start[1]

		end_i = index_of_end[0]
		end_j = index_of_end[1]
                
		wall.each_index do|i|
			#puts i
			@array[wall[i][0]][wall[i][1]]="w"
		end
		
		@array[start_i][start_j]="s"
		@array[end_i][end_j]="e"

		# Start of Algorithm
		puts "Your Grid is:"
		print " #{@array} \n "
		@openList[[start_i,start_j]] = [0, 0, 0, nil, nil]
		extract_list(start_i, start_j, end_i, end_j)
		list = []
		extract_path( end_i,end_j, start_i, start_j,list)
		print [end_i, end_j] << list #would this be correct or should it be list=extractPath 
	end
	


	def extract_list(current_i, current_j, end_i,end_j)
		until @closedList.include?([end_i, end_j]) || @openList.empty?
			count = 0
			count1 = 0
			
			child_i= current_i-1
			child_j= current_j-1
			while ((child_i)-current_i).abs<=1 || ((child_j)-current_j).abs<=1  do
				count +=1
				if (child_i >=0 && child_j >=0) && (child_i < @height && child_j <@width)
					if (child_i != current_i || child_j != current_j) 	
						if !@openList.include?([child_i, child_j]) && !@closedList.include?([child_i, child_j]) && @array[child_i][child_j] != "w"
							hash= calc_G_H_F(child_i,child_j, current_i, current_j, end_i, end_j)
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
			extract_list(key[0], key[1], end_i, end_j)
#			
		end
	end
	




	def calc_G_H_F(child_i,child_j, parent_i,parent_j, end_i,end_j)
		
		value = @openList[[parent_i,parent_j]]
		if (child_i-parent_i).abs == 1 && (child_j-parent_j).abs == 1		
			g=value[0]+14
		else
			g=value[0]+10
		end			
		h = (child_i-end_i).abs*10 + (child_j-end_j).abs*10
		f=h+g
		hash= [f, g, h, parent_i, parent_j]	
	end

	def extract_path(cell_i, cell_j, start_i, start_j, list) #DONT use instance variable $list
		until cell_i == start_i && cell_j == start_j
			parent_values= @closedList[[cell_i, cell_j]]
			cell_i = parent_values[3]
			cell_j = parent_values[4]	
			list << [cell_i, cell_j]
			
			extract_path(cell_i, cell_j, start_i, start_j, list)
			cell_i = start_i
			cell_j = start_j
		end
		list #what happens if Ruby is pass by value, what about pass by reference
		
	end
	
end

astar = Astar.new(15,15)

wall = [[5,5],[5,6], [7,8], [8,8], [14,3], [14,4],[14,5]]
index_of_start = [1,3]
index_of_end = [12,13]
astar.find_path(index_of_start, index_of_end, wall)


