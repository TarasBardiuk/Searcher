class StaticPagesController < ApplicationController
  def home
    run Filter::JSONFile
    @data = result['data']
  end
end
