=begin
    File: driver.rb
    Author:
    Date Created: 9/8/17
    Description:
=end

class Driver

    def initialize
        @size = 95
    end

    def title_print(title)

        title_size = title.length

        # top line
        print "\n\u250C"
        for i in 0...@size
            print "\u2500"
        end
        print "\u2510\n"

        # title line
        print "\u2502 \u25B6 #{title} "
        for i in 0...(@size-4 - title_size)
            if i == (@size - 3)
                print "\u2513"
            else
                print " "
            end
        end
        print "\u2502\n"

        # bottom line
        print "\u2514"
        for i in 0...@size
            print "\u2500"
        end
        print "\u2518\n"
    end

<<<<<<< HEAD
    def sub_title_print(title)

        title_size = title.length

        # title line
        print "\u2502   \u25B6 #{title} "
        for i in 0...(@size - (title_size+6))
            print " "
=======
    #for use with sub title print onyl
    def title_print_ext(title)
        
        title_size = title.length

        # top line
        print "\n\u250C"
        for i in 0...@size
            print "\u2500"
        end
        print "\u2510\n"

        # title line
        print "\u2502 \u25B6 #{title} "
        for i in 0...(@size-4 - title_size)
            if i == (@size-7 - title_size)
                print "\u2517"
            else
                print " "
            end
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
        end
        print "\u2502\n"

        # bottom line
        print "\u2514"
        for i in 0...@size
<<<<<<< HEAD
=======
            if i == 3
                print "\u252C"
            else
                print "\u2500"
            end
        end
        print "\u2534\u2500\u2500\u2500\u2510\n"
    end

    def sub_title_print(title)
        
        title_size = title.length

        # title line
        print "    \u2502 \u25B6 #{title} "
        for i in 0...(@size - (title_size+4))
            if i == (@size-7 - title_size)
                print "\u2517"
            else
                print " "
            end
        end
        print "\u2502\n"

        # bottom line
        print "    \u2514"
        for i in 0...@size
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
            print "\u2500"
        end
        print "\u2518\n"
    end

    def menu_builder(option_array)

<<<<<<< HEAD

    option_array.each do |option|
=======
        
    option_array.each do |option|            
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
        puts " \u21E8 #{option}"
    end

    menu_choice = choice_getter(1,option_array.length)
    return menu_choice
<<<<<<< HEAD

    end

    def choice_getter(low,high)

=======
    
    end
        
    def choice_getter(low,high)
        
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
        choice = 0

        while (choice < low || choice > high)
            print "Please make a selection: "
<<<<<<< HEAD
            choice = gets.to_i
=======
            choice = STDIN.gets.to_i
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
        end

        return choice

    end
<<<<<<< HEAD
end
=======

    def hr
        for i in 0...@size+2
            if i > 3
                print "-"
            else
                print " "
            end
        end
    end

    def desc_printer(string)
        @length = string.length.clone
        string = string.split(' ')

        @new_string = String.new
        @first_line = true

        for i in 0...string.length
            @new_string = @new_string + string[i] + " "

            if @first_line
                if @new_string.length > 60
                    print @new_string + "\n"
                    @new_string = "\t\t\t"
                    @first_line = false
                end
                
            else 
                if @new_string.length > 85
                    print @new_string + "\n"
                    @new_string = "\t\t\t"
                end
            end

        end

        print @new_string + "\n"

    end
end
>>>>>>> 9e2b8d5b2f88627338a8e31614a3d296a12c5142
