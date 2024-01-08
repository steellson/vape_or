import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {

    //MARK: Posgres setup
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    
    //MARK: Migrations
    do {
        try await app.autoMigrate()
        app.migrations.add(CreateTodo())
    } catch {
        throw Abort(.init(statusCode: 600, reasonPhrase: "Automigration error!"))
    }
    
    //MARK: Views
    app.views.use(.leaf)

    
    //MARK: Routes
    try routes(app)
}
