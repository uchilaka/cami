/**
 * TODO: Use a more appropriate format for this file that unlocks
 *   inference of the MongoDB JavaScript context.
 */
use doc_store_development;

db.createUser({
  user: "db_admin",
  pwd: `${process.env.MONGO_INITDB_ROOT_PASSWORD}`,
  roles: [
    { role: "dbOwner", db: "doc_store_development" },
  ]
});

use doc_store_test;

db.createUser({
  user: "db_admin",
  pwd: `${process.env.MONGO_INITDB_ROOT_PASSWORD}`,
  roles: [
    { role: "dbOwner", db: `doc_store_test` },
  ]
});

// use admin;
//
// db.createUser({
//   user: "db_admin",
//   pwd: `${process.env.MONGO_INITDB_ROOT_PASSWORD}`,
//   roles: [
//     { role: "dbOwner", db: "doc_store_development" },
//     { role: "dbOwner", db: "doc_store_test" },
//   ]
// });
