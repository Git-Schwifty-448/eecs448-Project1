=begin
    File: driver.rb
    Author:
    Date Created: 9/8/17
    Description:
=end

class Driver

    def initialize
        @size = 75
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
        for i in 0...(@size - (title_size+4))
            print " "
        end
        print "\u2502\n"

        # bottom line
        print "\u2514"
        for i in 0...@size
            print "\u2500"
        end
        print "\u2518\n"
    end

    def sub_title_print(title)

        title_size = title.length

        # title line
        print "\u2502   \u25B6 #{title} "
        for i in 0...(@size - (title_size+6))
            print " "
        end
        print "\u2502\n"

        # bottom line
        print "\u2514"
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
            choice = gets.to_i
        end

        return choice

    end
end
