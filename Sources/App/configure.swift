//import FluentSQLite
//import FluentMySQL
import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    // SQLite
    // try services.register(FluentSQLiteProvider())
    // try services.register(FluentMySQLProvider())
    try services.register(FluentPostgreSQLProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    // let sqlite = try SQLiteDatabase(storage: .memory)
    
    /// Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    // databases.add(database: sqlite, as: .sqlite)
//
//
////    let databaseConfig = MySQLDatabaseConfig(hostname: "localhost", username: "vapor", password: "password", database: "vapor")
//
////    let database = MySQLDatabase(config: databaseConfig)
////    databases.add(database: database, as: .mysql)
//
//    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost", username: "vapor", database: "vapor", password: "password")
//    let database = PostgreSQLDatabase(config: databaseConfig)
//    databases.add(database: database, as: .psql)
//
//    services.register(databases)
    
    // 1
    var databases = DatabasesConfig()
    // 2
    let hostname = Environment.get("DATABASE_HOSTNAME")
        ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD")
        ?? "password"
    // 3
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        username: username,
        database: databaseName,
        password: password)
    // 4
    let database = PostgreSQLDatabase(config: databaseConfig)
    // 5
    databases.add(database: database, as: .psql)
    // 6
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    // migrations.add(model: Acronym.self, database: .sqlite)
    // migrations.add(model: Acronym.self, database: .mysql)
    migrations.add(model: Acronym.self, database: .psql)
    services.register(migrations)

}
