//! `SeaORM` Entity. Generated by sea-orm-codegen 0.11.3

use sea_orm::entity::prelude::*;

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, Eq)]
#[sea_orm(table_name = "account")]
pub struct Model {
    #[sea_orm(primary_key)]
    pub id: i64,
    pub created_at: DateTime,
    pub updated_at: DateTime,
    pub username: String,
    pub domain: Option<String>,
    pub display_name: String,
    pub note: String,
    #[sea_orm(unique)]
    pub uri: String,
    pub url: Option<String>,
    pub inbox_url: String,
    pub outbox_url: String,
    pub shared_inbox_url: String,
    pub followers_url: String,
    #[sea_orm(column_type = "Text", nullable)]
    pub private_key: Option<String>,
    #[sea_orm(column_type = "Text")]
    pub public_key: String,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(has_many = "super::favorite::Entity")]
    Favorite,
    #[sea_orm(has_many = "super::status::Entity")]
    Status,
    #[sea_orm(has_many = "super::user::Entity")]
    User,
}

impl Related<super::favorite::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Favorite.def()
    }
}

impl Related<super::status::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Status.def()
    }
}

impl Related<super::user::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::User.def()
    }
}

impl ActiveModelBehavior for ActiveModel {}
