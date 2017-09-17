=begin
    File: driver.rb
    Author:
    Date Created: 9/8/17
    Description:
=end

class Driver

    def initialize
        @size = 95
        @spacer = "        "
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
        end
        print "\u2502\n"

        # bottom line
        print "\u2514"
        for i in 0...@size
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
            print "\u2500"
        end
        print "\u2518\n"
    end

    def menu_builder(option_array)
        option_array.each do |option|
            puts " \u21E8 #{option}"
        end

        menu_choice = choice_getter(1,option_array.length)
        return menu_choice
    end

    def choice_getter(low,high)

        choice = 0

        while (choice < low || choice > high)
            print "Please make a selection: "
            choice = STDIN.gets.to_i
        end

        return choice

    end

    def menu_builder_ext(option_array)
        option_array.each do |option|
            puts "         \u21E8 #{option}"
        end

        menu_choice = choice_getter_ext(1,option_array.length)
        return menu_choice
    end

    def choice_getter_ext(low,high)

        choice = 0

        while (choice < low || choice > high)
            print "        Please make a selection: "
            choice = STDIN.gets.to_i
        end

        return choice

    end


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
        @length = string.length
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

    # Takes a string (message) and validates user input to only allow
    # responses that only contain upper and lowercase letters
    def get_alpha(message)
        loop do
            print message
            @input = STDIN.gets.chomp

            if @input.match(/^[[:alpha:]]+$/)
                break
            else
                print "\n#{@spacer}Only letters are allowed"
            end
        end

        return @input
    end

    # takes an array of acceptable answers and only allows the user to
    # choose from that list
    def validate_input(acceptable_input)
        @user_input = ""

        while !acceptable_input.include? @user_input
            print "\n#{@spacer}Choice: "
            @user_input = STDIN.gets.chomp
        end

        return @user_input
    end
end
