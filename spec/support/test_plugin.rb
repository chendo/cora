
class TestPlugin < Cora::Plugin

  listen_for /test/ do
    say "test!"
  end

  listen_for /^foo$/ do
    say "foo"
    set_state :waiting_for_bar
  end

  listen_for /send message/ do
    receipent = ask "Who should I send it to?"
    say "Sending message to #{receipent}"
  end

  listen_for /ask multiple/ do
    answer = ask "Question 1"
    say "You said: #{answer}"
    answer = ask "Question 2"
    say "You said: #{answer}"
    answer = ask "Question 3"
    say "You said: #{answer}"
  end

  listen_for /confirm something/ do
    confirm "Does confirm work?" do |confirmed|
      if confirmed
        say "Confirmed"
      else
        say "Canceled"
      end
    end
  end

  listen_for /confirm custom reprompt/ do
    confirm "Does confirm work?", unmatched_message: "What you say!?" do |confirmed|
      if confirmed
        say "Confirmed"
      else
        say "Canceled"
      end
    end
  end


  listen_for /nested confirm/ do
    confirm "Does confirm work?" do |confirmed|
      if confirmed
        say "Confirmed"
        confirm "What about inside itself?" do |confirmed2|
          if confirmed2
            say "Confirmed2"
          else
            say "Canceled2"
          end
        end
      else
        say "Canceled"
      end
    end
  end

  listen_for /sequential confirm/ do
    confirm "Does confirm work?" do |confirmed|
      if confirmed
        say "Confirmed"
      else
        say "Canceled"
      end
    end
    confirm "And a second time?" do |confirmed|
      if confirmed
        say "Confirmed2"
      else
        say "Canceled2"
      end
    end
    confirm "And a third time?" do |confirmed|
      if confirmed
        say "Confirmed3"
      else
        say "Canceled3"
      end
    end
  end

  listen_for /bar/, within_state: :waiting_for_bar do
    say "bar get"
  end

  listen_for /my name is (\w+) (\w+)/i do |first_name, last_name|
    say "Nice to meet you, #{first_name} #{last_name}"
  end

  listen_for /only repeat this/i do
    say "#{match_data}"
  end
end
