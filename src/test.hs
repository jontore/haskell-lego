{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
-- | moves a robot using two tracks on engines B & C
-- the robot moves tills the tactile sensor is pressed, then it reverse a little, turns and start again
module Main where

import Robotics.NXT

import Robotics.NXT.Samples.Helpers
import Robotics.NXT.Sensor.Ultrasonic

import System.Environment (getArgs)
import Control.Concurrent (threadDelay,forkIO)
import Control.Monad.IO.Class (liftIO)

import Data.IORef
import System.IO
import Control.Monad.State.Lazy (evalStateT)
import Control.Monad.Trans.Class (lift)

-- | the main method
main :: IO()
main = do
        (device:_)<-getArgs
        iorC<-newIORef True
        forkIO (do
                hSetBuffering stdin NoBuffering
                hSetBuffering stdout NoBuffering -- does not Work on windows
                putStrLn "press space to stop robot"
                waitForStop iorC
                putStrLn "stopping..."
                return ()
                )
        withNXT device (do
                usInit Four
                evalStateT (do
                  resetMotors
                  moveForward (-75)
                  forever loop
                  resetMotors
                  ) (pollForStopIOR iorC)
                usSetMode Four Off
                liftIO $ threadDelay 1000000  -- wait before killing everything probably not needed after reset
                )
        --killThread tid

motors = [B, C]

resetMotors = reset motors

measureDistanceAndAct = do
  liftIO $ print "act on discace"
  m <- getDistance
  liftIO $ print m

  actOnDistance m

actOnDistance:: Int -> StopSt()
actOnDistance m | m < 20 = backAndTurn
                | m < 60 = moveForwardTurn (-75)
                | otherwise = moveForward (-75)

getDistance = do
  mM <- lift $ usGetMeasurement Four 0
  case mM of
    Just m -> return m
    Nothing-> return 100

blockUntilSound = do
  lift $ setInputModeConfirm Two SoundDB PctFullScaleMode
  pollForScaled Two 90

backAndTurn = do
  resetMotors
  liftIO $ print "back"
  move motors 75 [0,0] 1500
  liftIO $ print "wait for sound"
  --blockUntilSound
  liftIO $ print "turn"
  move motors 75 [100, -100] 500
  stop motors -- stop

moveForward x = do
  liftIO $ print "move forward"
  move motors x [0, 0] 0 -- move forever

moveForwardTurn x = do
  resetMotors
  liftIO $ print "move forward turn"
  move motors x [100, -100] 0 -- move forever


loop :: StopSt()
loop = do
  measureDistanceAndAct
  liftIO $ threadDelay 500



