import express from "express";
import bodyParser from "body-parser";
const pgp = require("pg-promise")();
import waitForPort from "wait-for-port";

function renderHtml(variables) {
  const { title, content } = variables;
  return `<html>
    <head>
      <title>${ title }</title>
    </head>
    <body>
      ${ content }
      <hr />
      <form action="/" method="post">
        <div>
          <label for="firstName">Prénom</label>
          <input type="text" id="firstName" name="firstName" />
        </div>
        <div>
          <label for="lastName">Nom</label>
          <input type="text" id="lastName" name="lastName" />
        </div>
        <input type="submit" value="Ajouter" />
      </form>
    </body>
  </html>`
}

process.on("SIGINT", () => {
  process.exit();
});

// On récupère les informations nécessaires pour réaliser la connexion.
const databaseHost = "postgres"
const databaseUser = process.env.POSTGRES_USER || "demo";
const databasePassword = process.env.POSTGRES_PASSWORD || "demo";
const databasePort = 5432;

// On initialise la connection à la base de données
const database = pgp({
  user: databaseUser,
  database: databaseUser, // Plus simple, par convention, etc.
  password: databasePassword,
  host: databaseHost,
  port: databasePort,
  max: 10,
  idleTimeoutMillis: 30000,
});

function createTableIfNotExists(client) {
  return client.tx(t=>{
    return t.oneOrNone("SELECT 1 FROM information_schema.tables t WHERE t.table_schema = current_schema() AND t.table_name = $1", "collaborators", r=>!!r)
      .then(result=>{
            return result || t.none("CREATE TABLE collaborators(first_name TEXT NOT NULL, last_name TEXT NOT NULL)").then(()=>true);
         })
      .then(tableCreated => {
        if (tableCreated) {
          return t.batch([
               t.none("INSERT INTO collaborators(first_name, last_name) VALUES ($1, $2)", ["Xavier", "Pontoireau"]),
               t.none("INSERT INTO collaborators(first_name, last_name) VALUES ($1, $2)", ["Hugues", "Pringault"])   
            ])
            .then(() => true;);
      } else {
        return false;
      }
    });
  });
}

function listCollaborators(request, response) {
  database.any("SELECT * FROM collaborators")
    .then((results) => {
      return `<ul>${ results.map((result) => { return `<li>${ result["last_name"] }, ${ result["first_name"] }</li>` }).join("") }</ul>`;
    })
    .then((content) => {
      response.send(renderHtml({
        title: "Docker",
        content
    }));
  });
}

function insertCollaborators(request, response) {
  console.log(request.body);
  database.none("INSERT INTO collaborators(first_name, last_name) VALUES($1, $2)", [request.body["firstName"], request.body["lastName"]])
    .then(() => {
      response.redirect("/");
    });
}

function createApp() {
  const app = express()
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.get("/", listCollaborators);
  app.post("/", insertCollaborators)
  return app;
}

waitForPort(databaseHost, databasePort, (error) => {
  database.task(createTableIfNotExists)
    .then(createApp)
    .then((app) => {
      const server = app.listen(3000, () => {
        const { address, port } = server.address();
        console.log(`Listening at http://${address}:${port}`);
      });
    });
});
