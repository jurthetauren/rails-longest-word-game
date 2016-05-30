require 'open-uri'
require 'json'

class PagesController < ApplicationController
# Dit is de game section waarin je de grid aanmaak.
def game
  @time_start = Time.now.to_i
  new_grid = generate_grid
  @grid = new_grid
end

# .join(" ")

def generate_grid
  Array.new(10) { ('A'..'Z').to_a[rand(26)] }
end



# Hier begint de score controller die een paar dingen moet doen.
# We moeten de begin en de eind tijd weten om deze score werkend te kunnen krijgen.
def score
  input = params[:user_input]
  end_t = Time.now.to_i
  start_t = params[:start_time]
  used_grid = params[:grid]




  def included?(guess, grid)
    the_grid = grid.clone.split("")
    guess.chars.each do |letter|
      the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
    end
    grid.split("").size == guess.size + the_grid.size
  end

  def compute_score(attempt, time_taken)
    time_score = time_taken * 60.0
    size_score = attempt.size * (1.0 - time_taken / 60.0)
    score = time_score.to_i + size_score.to_i
    return score.to_i
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time.to_i - start_time.to_i }

    result[:translation] = get_translation(attempt)
    result[:score], result[:message] = score_and_message(
      attempt, result[:translation], grid, result[:time])

    result
  end

  def score_and_message(attempt, translation, grid, time)
    if translation
      if included?(attempt.upcase, grid)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not in the grid"]
      end
    else
      [0, "not an english word"]
    end
  end


  def get_translation(word)
    response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
    json = JSON.parse(response.read.to_s)
    json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
  end

  @result = run_game(input, used_grid, start_t, end_t)

end
end
