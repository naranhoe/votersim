#Version 05
class World_Ui
  attr_reader :world
  #this class interacts with the user and calls the methods of the
  #world class to perfom the actions requested.
  def initialize(world)
    @world = world
  end

  def main_menu
    # When user types "L" call the list method
    # When user types "C" prompt for v||p and call create
    puts
    puts
    puts
    input_cluvq = get_answer("Menu: What would you like to do?", "(C)reate, (L)ist, (U)pdate, (V)ote, or (Q)uit",["c", "l", "u", "v", "q"])
    case input_cluvq
    when "c"
      input_pv = get_answer("What would you like to create?", "(P)olitician or (V)oter", ["p", "v"])
      print "Enter name: "
      name = gets.chomp
      if input_pv == "p"
        party = get_answer("What is your party?", "(D)emocrat or (R)epublican", ["d", "r"])
        world.create_politician(name, party)
        return false
      else
        politics = get_answer("What are your politics? ", "(L)iberal, (C)onservative, (T)ea Party, (S)ocialist, or (N)eutral", ["l", "c", "t", "s", "n"])
        world.create_voter(name, politics)
        return false
      end
    when "l"
      if world.list("").any?
        puts "Here is your requested list:"
        world.list("")
      return false
      else
        puts "--- End of list ---"
    end
    when "u"
      type = get_answer("Who would you like to update?", "(P)oliticians or (V)oters",["v", "p"])
      world.list(type)
      print "Enter name: "
      name = gets.chomp
      person = world.find(name)
      if person.is_a? Politician
        update_politician = get_answer("What would you like to change?", "(N)ame or (P)arty", ["n", "p"]) #var saves n or p
        if update_politician == "p"
          update_party_to = get_answer("What party would you like to change to?", "(R)epublican or (D)emocrat", ["r", "d"])
          world.update_party(name, update_party_to)
        elsif update_politician == "n"
          print "What is your new name: "
          update_name_to = gets.chomp.downcase
          world.update_name(name, update_name_to)
        end
      elsif person.is_a? Voter
        update_voter = get_answer("What would you like to change?", "(N)ame or (P)olitics", ["n", "p"])
        if update_voter == politics
          update_politics_to = get_answer("What politics would you like to change to?", "(T)ea Party, (C)onservative, (N)eutral, (L)iberal, or (S)ocialist ", ["t", "c", "n", "l", "s"])
          world.update_politics(name)
        elsif update_voter == name
         print "What is your new name: "
         update_name_to = gets.chomp.downcase
         world.update_name(name, update_politics_to)
        end
      else
        puts "This person does not exist in our database."
        return false
      end
      return false
    when "v"
        @world.election
        return false
    when "q"
        system("clear")
        puts <<-EOP
        ==========================================================
        ==========================================================
        ====                                                  ====
        ====   THANKS FOR SIMULATING WITH VOTE-A-MATIC!!      ====
        ====                                                  ====
        ==========================================================
        ==========================================================

        Advanced voting simulation tools available only in that Irish pub,
        We've narrowed it down to there since you started simulating.

        Credits:
          Jim "Jim" Disser
          Jake "Jake" Jacobson
        also contributing
          Jorge Naranjo
          Stephanie Reyes

        Not many animals were harmed in the creation of this code.
        Any resemblance to people living or deceased or otherwise
        is intentional we assure you.

        Filmed in Panavision

        Bug Ridden Software Inc.

        EOP
        return true
    else
        puts "Please choose an option from the menu."
        return false
    end
  end

  def get_answer(prompt, choice, valid)
    is_valid = false
    while !is_valid do
      puts prompt
      print choice + " :"
      answer = gets.chomp.downcase
      is_valid = true if valid.include? answer
      puts "Please enter a menu selection " if !is_valid
    end
    return answer
  end

end


class Voter
  attr_accessor :name, :politics

  def initialize(name, politics)
    @name = name
    @politics = politics
  end
  #SR1018 returns a formatted string voter information
  def get_info
    @output = "Voter, #{@name}, #{@politics}"
  end
end

class Politician    #JRD1017 added votes
  attr_accessor :name, :party, :votes

  def initialize(name, party)
    @name = name
    @party = party
    @votes = 0
  end

  #SR1018 returns a formatted string politician information
  def get_info
    @output = "Politician, #{@name}, #{@party}"
  end



end

class World
  #this class performs all the actions for the simulation and hold
  #all of the players and results

    attr_accessor :voters, :politicians, :total_votes

    def initialize    #JRD1017 added to init instance vars
      @voters = []        #array of voter objects
      @politicians = []   #array of politician objects
      @total_votes = {}   #hash containing politician:  votes
    end

    def create_politician(name, party)
      #create a Politician/Voter with the parameters
      politician = Politician.new(name, party)
      @politicians << politician
      puts
      puts "Created Politician : #{politician.name} (#{politician.party})"
      puts
    end

    def create_voter(name, politics)
      #create a Politician/Voter with the parameters
      voter = Voter.new(name, politics)
      @voters << voter
      puts
      puts "Created Voter : #{voter.name} (#{voter.politics})"
    end

    def update_name(name, update_name_to)
      person = find(name)
      person.name = update_name_to
    end

    def update_party(name, update_party_to)
      person = find(name)
      person.party = update_party_to
    end

    def update_politics(name, update_politics_to)
      person = find(name)
      person.politics = update_politics_to
    end

    def testdata #JRD1017
      #A method to generate an array of voters and of politicians for testing

      #create an array of voters from a file with a list of random names
      politics = %w[t c n l s]
      File.open("voters.txt") do |file|
          file.each_line do |line|
            name = line.chomp.strip
            @voters << Voter.new(name, politics[rand(4)])
          end
      end
      #puts the array for testing
      # puts "Voters from file"
      # puts
      # @voters.each do |voter|
      #   puts "#{voter.name}|  |#{voter.politics}|"
      # end

      #create a small array of politicians manually
      @politicians << Politician.new("Donald Trump", "r")
      @politicians << Politician.new("Jeb Bush", "r")
      @politicians << Politician.new("Hillary Clinton", "d")
      @politicians << Politician.new("Bernie Sanders", "d")

      # p @politicians

    end
    def print_list(list)        #SR1018 original version
      list.each do |person|
        puts person.get_info
      end
    end

    def list(type)              #SR1018 original version
      if type == "p"
        print_list(@politicians)
      elsif type == "v"
        print_list(@voters)
      else
        print_list(@politicians)
        print_list(@voters)
      end
    end


    def election  #JRD1017 original version

      #This hash contains the probability of a voter with given politics
      #voting democrat. If a random number(1,100) is less than this the voter
      #voted democrat else republican.

      vote_prob = {"t" => 10, "c" => 25, "n" => 50, "l" => 75, "s" => 90}

      #sort the politicians into arrays of democrats and republicans
      democrats = []
      republicans = []
      @politicians.each do |candidate|
        candidate.votes = 0                   #clear the vote count
        if candidate.party == "d"
          democrats << candidate
        else
          republicans << candidate
        end
      end

      #get the number of candidates in each party
      num_dem = democrats.length
      num_rep = republicans.length

      #for each voter simulate voting and record the total in the politician object
      @voters.each do |voter|
        if rand(1..100) <= vote_prob[voter.politics]
          democrats[rand(0..(num_dem - 1))].votes += 1  #pick a random dem and record vote
        else
          republicans[rand(0..(num_rep - 1))].votes += 1 #otherwise vote goes to random rep
        end
      end
      total_votes = {}
      total_votes.clear                      #remove any old results
      puts "Election Results:"
      puts

      @politicians.each do |candidate|        #generate hash and politician votes
        candidate.votes += 1                  #cadidates always vote for themselves
        total_votes[candidate.name] = candidate.votes
        puts "#{candidate.name} has #{candidate.votes} votes."
      end

      vote_tally = []
      winner = ""
      tie = ""
      tie_votes = 0
      max_votes = 0
      total_votes.each_pair do |candidate, votes|
        if votes > max_votes
          winner = candidate.upcase
          max_votes = votes
        elsif votes = max_votes
          tie = candidate.upcase
          tie_votes = votes
        end
      end
      puts
      puts "=============================================="
      puts "=============================================="
      puts "====                                      "
      puts "==== AND THE WINNER IS #{winner}!!!!"
      puts "====                                      "
      puts "=============================================="
      puts "=============================================="

      # if max_votes = tie_votes
      #   puts "THERE HAS BEEN A TIE BETWEEN #{winner} AND #{tie}!! WHAT ARE THE ODDS, seriously though... "
      # else
      #   puts "AND THE WINNER IS #{winner}!!!!"
      # end
    end

    def find(name) #JRD1018 original version
      #returns the object with name if found if found,
      #returns false name is not currently in list of objects
      @politicians.each do |politician|
        return politician if politician.name.downcase == name.downcase
      end
      @voters.each do |voter|
        return voter if voter.name.downcase == name.downcase
      end
      return false
    end
end

#creating a my_world var to store world then passing that world into world Ui
#then using that world UI in the my_world that we created.
system("clear")
puts <<-EOP
==========================================================
==========================================================
====                                                  ====
====   WELCOME TO THE NEW AND IMPROVED VOTE-A-MATIC   ====
====                                                  ====
==========================================================
==========================================================

We've been working round the clock to create the most
advanced voting simulation tools available anywhere from
about 4th street to near that Irish pub, not to be too
specific about it.

We'll I'm sure you want to get on with it so please select
your choice from the menu below, and happy simulating!!!

EOP
my_world = World.new
my_worldUi = World_Ui.new(my_world)
# my_world.testdata
until my_worldUi.main_menu
end

# p my_world.find("Lacy Jerabek")
# p my_world.find("jim disser")
# p my_world.find("Donald Trump")

# my_world.election
# my_world.list("p")
# my_world.list("v")
# my_world.list("")
