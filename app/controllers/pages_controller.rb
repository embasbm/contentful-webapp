class PagesController < ApplicationController
  def index
    @recipes = client.entries(include: 2, content_type: 'recipe')
  end

  def show
    @recipe = client.entries(include: 2, content_type: 'recipe', 'sys.id' => params[:id]).first
    @tags = client.entries(include: 2, content_type: 'tag', 'sys.id' => @recipe.tags&.map(&:id))
    @chef = client.entries(include: 2, content_type: 'chef', 'sys.id' => @recipe.chef&.id).first
  rescue Contentful::EmptyFieldError => e
    Rails.logger.error e
    @tags ||= []
  end

  private
  def client
    @client ||= Contentful::Client.new(
      access_token: Rails.application.credentials.contentful[:access_token],
      space: Rails.application.credentials.contentful[:space],
      dynamic_entries: :auto,
      raise_errors: true
    )
  end
end
