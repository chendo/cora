require 'geocoder'

class Cora::Location

  extend Forwardable

  def_delegators :result, :address, :city, :state, :state_code, :country, :country_code, :postal_code

  attr_reader :latitude, :longitude, :extra

  def initialize(latitude, longitude, extra = {})
    @latitude = latitude
    @longitude = longitude
    @extra = extra
  end

  # Returns nil if geolocation failed, or an instance of Geocoder::Result::Google
  # See: http://rubydoc.info/github/alexreisner/geocoder/master/Geocoder/Result/Google
  def result
    results.first
  end

  # Returns an array of objects of class Geocoder::Result::Google (probably)
  def results
    @results ||= perform_reverse_geocode
  end

  private

  def perform_reverse_geocode
    Geocoder.search([latitude, longitude].join(','))
  end

end
