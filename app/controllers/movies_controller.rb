class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if( params[:ratings]!= nil)
        session[:ratings]=params[:ratings]
    end
    if(params[:sort_param])
      session[:sort_param]=params[:sort_param]
    end
    
    @all_ratings = Movie.all_ratings
    
    @ratings = session[:ratings] || Hash[Movie.all_ratings.map{|rating| [rating,1]}]
    
    
    @selected = @ratings.keys
    
    @movies = Movie.where(rating: @ratings.keys)
    @movies = @movies.order(session[:sort_param])  # { |m| m.params[:sort_param]}
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

end
