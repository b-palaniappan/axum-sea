use db::entity::sea_orm_active_enums::Type;
use dotenvy::dotenv;
use sea_orm::{ActiveModelTrait, ConnectOptions, Database, EntityTrait, Set};
use std::time::Duration;
use tracing::info;

use crate::db::entity::events;
use crate::db::entity::events::Entity as Events;

pub mod db {
    pub mod entity;
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::DEBUG)
        .with_test_writer()
        .init();

    dotenv().ok();

    let db_url = std::env::var("DATABASE_URL").unwrap();
    let mut opt = ConnectOptions::new(db_url);
    opt.max_connections(100)
        .min_connections(5)
        .connect_timeout(Duration::from_secs(5))
        .acquire_timeout(Duration::from_secs(5))
        .idle_timeout(Duration::from_secs(8))
        .max_lifetime(Duration::from_secs(8))
        .set_schema_search_path("axum".into());

    let db = Database::connect(opt).await.unwrap();

    let event = events::ActiveModel {
        r#type: Set(Type::Auth),
        name: Set("Hello World".to_owned()),
        ..Default::default()
    };

    let response = event.save(&db).await.unwrap();
    info!("Saved Value --> {:?}", response);

    let event_found = Events::find_by_id(2 as u64).one(&db).await.unwrap();
    info!("Search Value --> {:?}", event_found);

    println!("Hello, world!");
}
