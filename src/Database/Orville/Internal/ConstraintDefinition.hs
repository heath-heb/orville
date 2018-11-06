{-|
Module    : Database.Orville.Internal.ContraintDefinition
Copyright : Flipstone Technology Partners 2016-2018
License   : MIT
-}
module Database.Orville.Internal.ConstraintDefinition
  ( uniqueConstraint
  , dropConstraint
  ) where

import Data.List (intercalate)

import Database.Orville.Internal.FieldDefinition
import Database.Orville.Internal.Types

uniqueConstraint ::
     String
  -> TableDefinition readEntity writeEntity key
  -> [SomeField]
  -> ConstraintDefinition
uniqueConstraint name tableDef fields =
  ConstraintDefinition
    { constraintName = name
    , constraintTable = tableName tableDef
    , constraintBody =
        "UNIQUE (" ++ intercalate "," (map someEscapedFieldName fields) ++ ")"
    }
  where
    someEscapedFieldName (SomeField f) = escapedFieldName f

dropConstraint ::
     TableDefinition readEntity writeEntity key -> String -> SchemaItem
dropConstraint tableDef = DropConstraint (tableName tableDef)
