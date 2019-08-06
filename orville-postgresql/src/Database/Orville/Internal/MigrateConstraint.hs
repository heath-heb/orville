{-|
Module    : Database.Orville.Internal.MigrateConstraint
Copyright : Flipstone Technology Partners 2016-2018
License   : MIT
-}
{-# LANGUAGE RecordWildCards #-}

module Database.Orville.Internal.MigrateConstraint
  ( createConstraintPlan
  , dropConstraintPlan
  ) where

import Control.Monad
import Data.List

import Database.Orville.Internal.MigrationPlan
import Database.Orville.Internal.SchemaState
import Database.Orville.Internal.Types

createConstraintPlan ::
     ConstraintDefinition -> SchemaState -> Maybe MigrationPlan
createConstraintPlan constraintDef schemaState = do
  guard
    (not $
     schemaStateConstraintExists (constraintName constraintDef) schemaState)
  pure $
    migrationDDLForItem
      (Constraint constraintDef)
      (intercalate
         " "
         [ "ALTER TABLE"
         , "\"" ++ constraintTable constraintDef ++ "\""
         , "ADD CONSTRAINT"
         , "\"" ++ constraintName constraintDef ++ "\""
         , constraintBody constraintDef
         ])

dropConstraintPlan :: String -> String -> SchemaState -> Maybe MigrationPlan
dropConstraintPlan tableName constraintName schemaState = do
  guard (schemaStateConstraintExists constraintName schemaState)
  pure $
    migrationDDLForItem
      (DropConstraint tableName constraintName)
      ("ALTER TABLE " ++ tableName ++ " DROP CONSTRAINT " ++ constraintName)