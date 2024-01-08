import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("test") { req async -> [String : Int] in
        ["test1" : 666]
    }

    try app.register(collection: TodoController())
}
