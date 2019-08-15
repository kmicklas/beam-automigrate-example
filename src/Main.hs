{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
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
  data PrimaryKey ItemT f = ItemId (Columnar f Int) deriving (Generic, Beamable)
  primaryKey = ItemId . itemId

data Db f = Db
  { dbItem :: f (TableEntity ItemT)
  } deriving (Generic, Database be)

db :: DatabaseSettings be Db
db = defaultDbSettings

checkedSqliteDb :: CheckedDatabaseSettings Sqlite Db
checkedSqliteDb = defaultMigratableDbSettings

main :: IO ()
main = do
  conn <- open "test.sqlite3"
  runBeamSqlite conn $ do
    autoMigrate migrationBackend checkedSqliteDb
