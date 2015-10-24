class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date) # what is this and what does it do 
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default #what does that mean 
  end

  def index
    #@all_ratings needs to be defined because of the copied code in Step 2
    @all_ratings = Movie.all_ratings # created a new method located in (app/models/movie.rb)
    
    #Branch statement is for the bullet point in part 3 that talks about being RESTful
    #Basically, if params[:rating] doesn't exist and session[:ratings] does,
    #or if params[:sort] doesn't exist and session[:sort] does, do this thing
    if( ( params[:ratings].nil? and session.has_key?(:ratings)) and ( params[:sort].nil? and session.has_key?(:sort)) )
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
   
    #Update session ratings to param[:ratings] if param[:ratings] isn't nil,
    #update it to @all_ratings if param[:ratings] and session[:ratings] are both nil,
    #or keep it at session[:ratings] if only param[:ratings] is nil
    session[:ratings] = (params[:ratings].nil?) ? (session[:ratings].nil?) ? @all_ratings : session[:ratings] : params[:ratings]
    
    session[:sort] = params[:sort] unless params[:sort].nil?
    
    #Reset button action
    if params[:commit] == "Reset"
      session.clear 
      session[:ratings] = @all_ratings
    end
    
    #A hash used in app/views/movies/index.html.haml for if a box is checked or not
    @checked ||= {}

    # keys gets the keys of the hash as an array (in this case ['G', 'PG', 'PG-13', 'R'] )
    # so it sets the hash of that key to true if the key is in the session[:ratings] hash
    @all_ratings.keys.each do |rating|
      @checked[rating] = session[:ratings].keys.include?(rating)
    end
    
    #Basically equivalent to the SQL statement:
    # SELECT * FROM movies WHERE rating IN session[:ratings].keys
    @movies = Movie.where(:rating => session[:ratings].keys)
    
    #Start part 1
    sort = session[:sort]#set sort equal to what the user chose ethier title or release date
    #debugger
    case sort
    when 'title'
      @title_header = "hilite"
      @movies = Movie.where(:rating => session[:ratings].keys).order("title")
    when "release"
      @release_header = "hilite"
      @movies = Movie.where(:rating => session[:ratings].keys).order("release_date")
    end
      #end of part 1 code
  end#end code here

  def new
    # default: render 'new' template # is this supposed to be commented out 
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created." #does this display the screeen 
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]# what is this and what does it do
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."#does this display the screeen 
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy# does the destroy meathod call its self ?
    flash[:notice] = "Movie '#{@movie.title}' deleted."#does this display the screeen 
    redirect_to movies_path
  end
  
  
  
  
end# end of class
