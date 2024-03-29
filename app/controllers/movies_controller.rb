class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (params[:ratings] == nil and session[:ratings]!=nil) or
      (params[:orderBy] == nil and session[:orderBy]!=nil)
      redirect_to movies_path(:orderBy => session[:orderBy], :ratings=>session[:ratings])
    end
    @checked = params[:ratings]? params[:ratings] : {}
    @all_ratings = []
#Movie.select("DISTINCT(RATING)").each {|s| @all_ratings<<s.rating} 
    Movie.find(:all, :select => 'distinct rating').each {|s| @all_ratings << s.rating} 
    @movies = Movie.find(:all,
        :order => ((params[:orderBy]+' ASC') if params[:orderBy] != nil),
        :conditions => ( ["rating IN (?)", @checked.keys] if params[:ratings]!=nil),
        )
    session[:ratings]=params[:ratings]
    session[:orderBy]=params[:orderBy]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
