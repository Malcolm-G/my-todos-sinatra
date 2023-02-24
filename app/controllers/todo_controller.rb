class TodoController < Sinatra::Base

    set :views,'./app/views'

    before do
        puts "Hello, to this route"
    end

    get '/hello' do
        "Welcome to TodoController"
    end

    get '/view/todos' do
        @todos = Todo.all
        erb :todos
    end

    post '/todos/create' do
        data = JSON.parse(request.body.read)

        begin
            # approach 1 (individual columns)
            # today = Time.now
            # title = data["title"]
            # description = data["description"]
            # todo = Todo.create(title: title, description: description, createdAt: today)
            # todo.to_json

            # approach 2 (hash of columns)
            today = Time.now
            data["createdAt"] = today
            todo = Todo.create(data)
            [201,todo.to_json]
        rescue => e
            [422,{
                error: "An error occurred while creating a new Todo"
        }.to_json]
        end
    end

    get '/todos' do

        todos = Todo.all
        [200,todos.to_json]
    end

    put '/todos/update/:id' do
        begin
            data = JSON.parse(request.body.read)
            todo_id = params['id'].to_i
            todo = Todo.find(todo_id)
            todo.update(data)
            {message:"todo updated successfully"}.to_json
        rescue => e
            [422,{error: e.messgae}.to_json]
        end
    end

    delete '/todos/delete/:id' do
        begin
            todo_id = params['id'].to_i
            todo = Todo.find(todo_id)
            todo.destroy
            {message:"todo destroyed successfully"}.to_json
        rescue => e
            {error: e.mesage}.to_json
        end
    end

end