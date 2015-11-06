require_relative "card_actions.rb"
def get_deck_name(user, deck, database)
  puts user
  puts deck
  return database['users'][user]["deck_names"][deck]
end

def show_decks(user,database)
  if database['users'][user]['deck_names']
    database['users'][user]['deck_names'].each_with_index do |deck, i|
      puts (i+1).to_s+") "+deck
    end
  else
    puts "You've got no decks to select!"
    return false
  end
end

def display_edit_menu(user,database)
  puts "Select a deck:"
  if show_decks(user,database)
    puts
    print "Enter selection: "
    deck_selection = gets.chomp.to_i-1

    if database['users'][user]['deck_names'][deck_selection]
      puts "Would you like to edit or delete that deck?"
      print "Edit/Delete (E/D)?: "
      edit_delete = gets.chomp.upcase
      case edit_delete
      when "E","EDIT"
        edit_deck(user,deck_selection, database)
      when "D" , "DELETE"
        delete_deck(user, deck_selection, database)
      else
        puts "Invalid selection  -- try again!"
        display_edit_menu(user, database)
      end
    else
      puts "That's not a deck -- try again!"
      display_edit_menu(user, database)
    end
  else
    menu(user, database)
  end
end

def edit_deck(user,deck, database)
  puts database["user_decks"][database['users'][user]["deck_names"][deck]]
  card_edit_menu(user, deck, database)

end

def create_deck(user, database)
  puts "What is the name of your deck?"
  puts
  print "Enter name: "
  deck_name = gets.chomp
  deck = {}
  deck['name'] = deck_name
  deck['user'] = user
  deck['cards'] = {}
  deck['json_index'] = "#{deck["name"].upcase}_#{deck["user"].upcase}".tr(' ', '_')
  if !database["user_decks"][deck["json_index"]]
    database["user_decks"][deck["json_index"]] = deck
    database["users"][user]["decks"] = {deck['json_index']=>true}
    update_database(database)
    edit_deck(user, database)
  else
    puts "Deck name already exists! Choose another name."
    create_deck(user, database)
  end
end

def delete_deck(user,deck, database)
  puts "Are you sure?"
  print "Y/N: "
  answer = gets.chomp
  if ["Y", "YES"].include?(answer.upcase)
    database['users'][user]['deck_names'].delete_at(deck)
    update_database(database)
  end
  menu(user, database)
end
