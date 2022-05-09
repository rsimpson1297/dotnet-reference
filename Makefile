.PHONY: bootstrap setup update run clean build test cibuild citest
.DEFAULT_GOAL := help

help: 
	echo "Primary goals are build, run, test, verify. 'make run' to execute"

# This is not required in coder - already in image
bootstrap: 
	dotnet tool install --global SpecFlow.Plus.LivingDoc.CLI

setup:
	dotnet restore

clean: 
	dotnet clean
	rm -rf ./test-results

build: clean
	dotnet build

test: build
	dotnet test --filter "TestCategory!=acceptance"

verify: build
	- dotnet test --filter "TestCategory=acceptance"
	- cp -r LevelUpGame.Tests/resources ./test-results
# May need export for M1 Mac Architecture
	- export DOTNET_ROOT=$(which dotnet) & livingdoc test-assembly LevelUpGame.Tests/bin/Debug/net6.0/LevelUpGame.Tests.dll -t LevelUpGame.Tests/bin/Debug/net6.0/TestExecution.json -o test-results/TestOutput.html

test-all: test verify

run:
	dotnet run --project LevelUpGame

cibuild: 
	dotnet build --no-restore

citest:
	dotnet test --no-build --verbosity normal
	- cp -r LevelUpGame.Tests/resources ./test-results
# May need export for M1 Mac Architecture
	- export DOTNET_ROOT=$(which dotnet) & livingdoc test-assembly LevelUpGame.Tests/bin/Debug/net6.0/LevelUpGame.Tests.dll -t LevelUpGame.Tests/bin/Debug/net6.0/TestExecution.json -o test-results/TestOutput.html