{-# LANGUAGE DeriveGeneric #-}
module Codex.Lib.Geo.World (
 Location (..),
 parseGeoNames
) where

import Codex.Lib.List
 (splitBy)

import System.IO
import Control.Monad
import Data.Aeson
import GHC.Generics

data Location = Location {
 _province :: String,
 _country :: String,
 _population :: Int
} deriving (Show, Read, Generic)

instance ToJSON Location
instance FromJSON Location

parseGeoNames :: FilePath -> IO [Location]
parseGeoNames name = do
 contents <- readFile name
 let parsed = map (\l -> line2rec $ splitBy '\t' l) $ lines contents
 return parsed

line2rec :: [String] -> Location
line2rec (geonameid:name:asciiname:alternatenames:latitude:longitude:featureclass:featurecode:countrycode:cc2:admin1:admin2:admin3:admin4:population:rest) =
 Location {
  _province = name,
  _country = countrycode,
  _population = read population :: Int
 }

{-
The main 'geoname' table has the following fields :
---------------------------------------------------
geonameid         : integer id of record in geonames database
name              : name of geographical point (utf8) varchar(200)
asciiname         : name of geographical point in plain ascii characters, varchar(200)
alternatenames    : alternatenames, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table, varchar(8000)
latitude          : latitude in decimal degrees (wgs84)
longitude         : longitude in decimal degrees (wgs84)
feature class     : see http://www.geonames.org/export/codes.html, char(1)
feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
country code      : ISO-3166 2-letter country code, 2 characters
cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
admin1 code       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)
admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
admin3 code       : code for third level administrative division, varchar(20)
admin4 code       : code for fourth level administrative division, varchar(20)
population        : bigint (8 byte int)
elevation         : in meters, integer
dem               : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
timezone          : the timezone id (see file timeZone.txt) varchar(40)
modification date : date of last modification in yyyy-MM-dd format
-}
