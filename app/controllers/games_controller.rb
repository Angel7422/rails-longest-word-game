require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @word = params[:word]

    @letters = ('A'..'Z').to_a.sample(10)
    @valid_words = valid_words_endpoint

    if valid_word?(@word, @letters) # Vérifie si le mot est valide selon les lettres fournies
      if valid_english_word?(@word, @valid_words) # Vérifie si le mot est anglais valide
        @result_message = "Le mot est valide d'après la grille et est un mot anglais valide."
      else
        @result_message = "Le mot est valide d'après la grille, mais ce n'est pas un mot anglais valide."
      end
    else
      @result_message = "Le mot ne peut pas être créé à partir de la grille d'origine."
    end

    render 'score'
  end

  private
  API = 'https://dictionary.lewagon.com/'.freeze

  def valid_words_endpoint
    uri = URI(API)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    endpoints = data['endpoints']
    endpoints.is_a?(Array) ? endpoints[0] : nil
  end

  def valid_word?(word, letters)
    endpoints = valid_words_endpoint
    endpoints || nil # Retourne les endpoints
  end

  def valid_english_word?(word, valid_words)
    return false unless valid_words

    uri = URI("#{API}#{word}") # Utilise valid_words pour construire l'URL
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data['found']
  end
end
