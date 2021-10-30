require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) {FactoryBot.create(:author, first_name: 'John', last_name: 'Doe', age: 35)}
  let(:second_author) {FactoryBot.create(:author, first_name: 'Jane', last_name: 'Smith', age: 39)}

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: 'We Make Love', author: first_author)
      FactoryBot.create(:book, title: 'We Go Home', author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'title' => 'We Make Love',
            'author_name' => 'John Doe',
            'author_age' => 35
          },
          {
            'id' => 2,
            'title' => 'We Go Home',
            'author_name' => 'Jane Smith',
            'author_age' => 39
          }
        ]
      )
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: {limit: 1}

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'title' => 'We Make Love',
            'author_name' => 'John Doe',
            'author_age' => 35
          }
        ]
      )
    end

    it 'returns a subset of books based on limit and offset' do
      get '/api/v1/books', params: {limit: 1, offset: 1}

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id' => 2,
            'title' => 'We Go Home',
            'author_name' => 'Jane Smith',
            'author_age' => 39
          }
        ]
      )
    end
  end

  describe 'POST /books' do
    let!(:user) {FactoryBot.create(:user, password: 'Password1')}

    it 'create a new book' do
      expect {
        post '/api/v1/books', params: {
          book: {title: 'The Title'},
          author: {first_name: 'John', last_name: 'Doe', age: 37}
        }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg" }
      }.to change {
        Book.count
      }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          'id' => 1,
          'title' => 'The Title',
          'author_name' => 'John Doe',
          'author_age' => 37
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) {FactoryBot.create(:book, title: 'We Make Love', author: first_author)}
    let!(:user) {FactoryBot.create(:user, password: 'Password1')}

    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}", headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg" }
      }.to change {
        Book.count
      }.from(1).to(0)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end