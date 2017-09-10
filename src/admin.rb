=begin

    File: admin.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

class Admin

        def initialize
          @fName, @lName = " ", " "
        end

        def run
          print getAdminInfo
        end

        #Accessor method
        def getFName
          @fName
        end

        def getLName
          @lName
        end

        #Setter method
        def setFName(theFName)
          @fName = theFName;
        end

        def setLName(theLName)
          @lName = theLName
        end

        #Receive admin's information
        def getAdminInfo
          print "Enter your First Name: "
          firstName = gets.chomp

          #Using Regexp class
          while !(firstName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your First Name: "
            firstName = gets.chomp
          end

          print "Enter your Last Name: "
          lastName = gets.chomp

          #Using Regexp class
          while !(lastName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your Last Name: "
            lastName = gets.chomp
          end

          setFName(firstName)
          setLName(lastName)

        end

    end
