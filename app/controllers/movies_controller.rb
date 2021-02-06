class MoviesController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = (params[:ratings] || session[:selected_ratings] || {})
    @selected_sort = (params[:sort] || session[:selected_sort] || nil) 
    
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    @ratings_to_show = @selected_ratings.keys if @selected_ratings != nil
    @movies = Movie.with_ratings(@ratings_to_show)
    
    session[:selected_ratings] = @selected_ratings
    session[:selected_sort] = @selected_sort
    
    if @selected_sort == "title"
      @titleCSS = "hilite bg-warning"
      @release_dateCSS = ""
      @movies = @movies.order(title: :asc)
    elsif @selected_sort== "release_date"
      @titleCSS = ""
      @release_dateCSS = "hilite bg-warning"
      @movies = @movies.order(release_date: :asc)
    end 

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :ratings, :description, :release_date, :sort, :direction)
  end
  
  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
