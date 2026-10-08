# Run with: RAILS_ENV=test bin/rails runner script/verify.rb
abort "Run verification in the test environment" unless Rails.env.test?

require "minitest/autorun"
require "action_dispatch/testing/integration"

class MoviesSmokeTest < ActionDispatch::IntegrationTest
  setup do
    Movie.delete_all
    Rails.application.load_seed
    @movie = Movie.find_by!(title: "Aladdin")
  end

  test "seeds remain unique when repeated" do
    Rails.application.load_seed
    assert_equal 4, Movie.count
  end

  test "root redirects to movies" do
    get "/"
    assert_redirected_to "/movies"
  end

  test "index, new, show, and edit render" do
    get movies_path
    assert_response :success
    assert_select "h1", "Movies"
    assert_select "a[href=?]", movie_path(@movie)
    get new_movie_path
    assert_response :success
    assert_select "form"
    get movie_path(@movie)
    assert_response :success
    assert_match "Aladdin", response.body
    get edit_movie_path(@movie)
    assert_response :success
    assert_select "form"
  end

  test "create saves all fields and ignores unpermitted attributes" do
    assert_difference "Movie.count", 1 do
      post movies_path, params: { movie: {
        title: "New film", rating: "PG", description: "A new story",
        release_date: "2026-10-07", created_at: "1999-01-01"
      } }
    end
    movie = Movie.find_by!(title: "New film")
    assert_redirected_to movie_path(movie)
    assert_equal "PG", movie.rating
    assert_equal "A new story", movie.description
    assert_equal Date.new(2026, 10, 7), movie.release_date.to_date
    assert_not_equal 1999, movie.created_at.year
    follow_redirect!
    assert_match "successfully created", response.body
  end

  test "update persists changes" do
    patch movie_path(@movie), params: { movie: {
      title: "Updated film", rating: "R", description: "Updated story",
      release_date: "2020-02-02"
    } }
    assert_redirected_to movie_path(@movie)
    @movie.reload
    assert_equal "Updated film", @movie.title
    assert_equal "R", @movie.rating
    assert_equal "Updated story", @movie.description
    assert_equal Date.new(2020, 2, 2), @movie.release_date.to_date
  end

  test "destroy removes the movie" do
    assert_difference "Movie.count", -1 do
      delete movie_path(@movie)
    end
    assert_redirected_to movies_path
    assert_not Movie.exists?(@movie.id)
  end

  test "JSON supports index, show, create, update, and destroy" do
    get movies_path(format: :json)
    assert_response :success
    assert_equal 4, response.parsed_body.length
    get movie_path(@movie, format: :json)
    assert_response :success
    assert_equal "Aladdin", response.parsed_body["title"]
    post movies_path(format: :json), params: { movie: {
      title: "JSON film", rating: "G", release_date: "2021-01-01"
    } }
    assert_response :created
    id = response.parsed_body["id"]
    patch movie_path(id, format: :json), params: { movie: { title: "JSON edit" } }
    assert_response :success
    assert_equal "JSON edit", response.parsed_body["title"]
    delete movie_path(id, format: :json)
    assert_response :no_content
  end
end
