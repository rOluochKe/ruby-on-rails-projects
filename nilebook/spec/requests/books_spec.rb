require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: 'We Make Love', author: 'John Doe')
      FactoryBot.create(:book, title: 'We Go Home', author: 'Jane Smith')
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(4)
    end
  end

  describe 'POST /books' do
    it 'create a new book' do
      expect {
        post '/api/v1/books', params: {book: {title: 'The Title', author: 'John Doe'} }
      }.to change {
        Book.count
      }.from(2).to(3)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) {FactoryBot.create(:book, title: 'We Make Love', author: 'John Doe')}

    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change {
        Book.count
      }.from(3).to(2)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end