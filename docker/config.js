var config,
    url = require('url'),
    path = require('path');

function getDatabase() {
  if (process.env.DATABASE_URL) {
    var dbUrl = url.parse(process.env['DATABASE_URL']);
    var auth = (dbUrl.auth || ':').split(':');
    var dbConfig = {
      client: dbUrl.protocol.slice(0, -1),
      connection: {
        host: dbUrl.hostname,
        user: auth[0],
        password: auth[1],
        port: dbUrl.port,
        database: dbUrl.pathname ? dbUrl.pathname.slice(1) : null
      }
    };
    return dbConfig;
  }

  if (process.env['DB_PORT']) {
    var dbUrl = url.parse(process.env['DB_PORT']);
    if (!process.env['DB_CLIENT'] || !process.env['DB_USER'] || !process.env['DB_PASSWORD'] || !process.env['DB_DATABASE']) {
      console.log("Environment variables DB_CLIENT, DB_USER, DB_PASSWORD and DB_DATABASE required when using Docker links");
      process.exit(1);
    }
    var dbConfig = {
      client: process.env['DB_CLIENT'],
      connection: {
        host: dbUrl.hostname,
        user: process.env['DB_USER'],
        password: process.env['DB_PASSWORD'],
        port: dbUrl.port,
        database: process.env['DB_DATABASE']
      }
    };
    return dbConfig;
  }

  var dbConfig = {
    client: 'sqlite3',
    connection: {
      filename: path.join(__dirname, '/content/data/ghost.db')
    },
    debug: false
  };
  return dbConfig;
}

if (!process.env.URL) {
  console.log("Please set URL environment variable to your blog's URL");
  process.exit(1);
}

config = {
  production: {
    url: process.env.URL,
    database: getDatabase(),
    server: {
      host: '0.0.0.0',
      port: '8080'
    }
  }
};
module.exports = config;
