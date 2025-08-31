-include .env
.PHONY: test
build:; forge build

test:; forge test

deploy-sepolia:
	forge script script/DeployFundMe.s.sol --rpc-url ${SEPOLIA_RPC} --account firstKey --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY}