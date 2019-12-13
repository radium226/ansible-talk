ThisBuild / organization := "radium226-talks-shapeless"
ThisBuild / scalaVersion := "2.13.1"
ThisBuild / version      := "1.0"

ThisBuild / scalacOptions ++= Seq(
  "-feature",
  "-deprecation",
  "-unchecked",
  "-language:postfixOps",
  "-language:higherKinds",
  "-Ymacro-annotations"/*,
  "-Ymacro-debug-lite"*/
)

ThisBuild / libraryDependencies ++= Seq(
  "org.typelevel" %% "cats-core" % "2.0.0",
  "com.chuusai" %% "shapeless" % "2.3.3",
  "org.scalactic" %% "scalactic" % "3.1.0", 
  "org.scalatest" %% "scalatest" % "3.1.0" % "test"
)

lazy val `step-01` = project

addCompilerPlugin("org.typelevel" %% "kind-projector" % "0.11.0" cross CrossVersion.full)
