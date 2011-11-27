
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
    if confirm "Does confirm work?"
      say "Confirmed"
    else
      say "Cancelled"
    end
  end

  listen_for /confirm custom reprompt/ do
    if confirm "Does confirm work?", unmatched_message: "What you say!?"
      say "Confirmed"
    else
      say "Cancelled"
    end
  end


  listen_for /nested confirm/ do
    if confirm "Does confirm work?"
      say "Confirmed"
      if confirm "What about inside itself?"
        say "Confirmed2"
      else
        say "Cancelled2"
      end
    else
      say "Cancelled"
    end
  end

  listen_for /sequential confirm/ do
    if confirm "Does confirm work?"
      say "Confirmed"
    else
      say "Cancelled"
    end
    if confirm "And a second time?"
      say "Confirmed2"
    else
      say "Cancelled2"
    end
    if confirm "And a third time?"
      say "Confirmed3"
    else
      say "Cancelled3"
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
