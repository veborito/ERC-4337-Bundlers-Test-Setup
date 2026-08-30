// script/Deploy.s.sol
import "forge-std/Script.sol";
import "../src/TestToken.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        TestToken token = new TestToken(1000000000, "UnineCoin", 18, "UNINE");
        vm.stopBroadcast();
        console.log("TestToken:", address(token));
    }
}
