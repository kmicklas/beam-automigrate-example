{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
module Main where

import Data.Monoid
import Data.Text

import Database.Beam
import Database.Beam.Migrate
import Database.Beam.Migrate.Simple
import Database.Beam.Sqlite
import Database.Beam.Sqlite.Syntax
import Database.Beam.Sqlite.Migrate
import Database.SQLite.Simple as Sqlite

data ItemT f = Item
  { itemId :: Columnar f Int
  , itemName :: Columnar f Text
  -- Try uncommenting this line and rerunning:
  -- , itemDescription :: Columnar f (Maybe Text)
  } deriving (Generic, Beamable)

instance Table ItemT where
  data PrimaryKey ItemT f = ItemId (Columnar f Int) deriving stock Generic deriving anyclass Beamable
  primaryKey = ItemId . itemId

newtype Db f = Db
  { dbItem :: f (TableEntity ItemT)
  }
  deriving stock Generic
  deriving anyclass (Database be)

db :: DatabaseSettings be Db
db = defaultDbSettings

checkedSqliteDb :: CheckedDatabaseSettings Sqlite Db
checkedSqliteDb = defaultMigratableDbSettings

main :: IO ()
main = do
  conn <- open "test.sqlite3"
  runBeamSqlite conn $
    autoMigrate migrationBackend checkedSqliteDb
