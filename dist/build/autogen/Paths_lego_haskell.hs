module Paths_lego_haskell (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/Users/jontore/Library/Haskell/ghc-7.6.3/lib/lego-haskell-0.1.0.0/bin"
libdir     = "/Users/jontore/Library/Haskell/ghc-7.6.3/lib/lego-haskell-0.1.0.0/lib"
datadir    = "/Users/jontore/Library/Haskell/ghc-7.6.3/lib/lego-haskell-0.1.0.0/share"
libexecdir = "/Users/jontore/Library/Haskell/ghc-7.6.3/lib/lego-haskell-0.1.0.0/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catchIO (getEnv "lego_haskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "lego_haskell_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "lego_haskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lego_haskell_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
