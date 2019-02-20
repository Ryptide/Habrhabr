#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'habrhabr.db'
	@db.results_as_hash = true
end

#вызывается каждый раз при перезагрузке любой страницы
before do
	#инициализация БД
	init_db
end

	#вызывается каждый раз при конфигурации приложения:
	#когда изменился код программы и перезагрузилась страница
configure do
	#инициализация БД
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "create_date" DATE, "content" TEXT)'
end

get '/' do
	#выбираем список постов из БД

	@results = @db.execute 'select * from Posts order by id desc'

	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	#получаем переменную из post запроса
	content = params[:content]

	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end

	#сохранение данных в БД

	@db.execute 'insert into Posts (content, create_date) values (?, datetime())', [content]

	erb "You typed #{content}"
end
