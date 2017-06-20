class StaticPagesController < ApplicationController
  def home
    @data = FilterService.data(params[:query])
  end
end
