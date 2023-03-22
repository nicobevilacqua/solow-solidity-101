// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 myToken;

    function setUp() public {
        myToken = new ERC20("myToken", "TKN", 18);
    }

    function test_name() public {
        assertEq(myToken.name(), "myToken");
    }

    function test_balanceOf() public {
        assertEq(myToken.balanceOf(address(0)), 0);
    }

    function test_totalSupply() public {
        assertEq(myToken.totalSupply(), 0);
    }

    function test_mint() public {
        address bob = makeAddr("bob");
        myToken.mint(bob, 100 ether);
        assertEq(myToken.balanceOf(bob), 100 ether);
    }

    function test_burn() public {
        address bob = makeAddr("bob");
        myToken.mint(bob, 100 ether);

        myToken.burn(bob, 100 ether);

        assertEq(myToken.balanceOf(bob), 0);
    }

    function test_transfer() public {
        address john = makeAddr("john");
        address alice = makeAddr("alice");

        deal(address(myToken), john, 10 ether);

        assertEq(myToken.balanceOf(john), 10 ether);

        vm.prank(john);
        myToken.transfer(alice, 5 ether);

        assertEq(myToken.balanceOf(alice), 5 ether);
        assertEq(myToken.balanceOf(john), 5 ether);
    }

    function test_allowance() public {
        address john = makeAddr("john");
        address alice = makeAddr("alice");

        assertEq(myToken.allowance(john, alice), 0);
    }

    function test_transferFrom() public {
        address bob = makeAddr("bob");
        address alice = makeAddr("alice");
        address john = makeAddr("john");

        deal(address(myToken), bob, 100 ether);

        vm.prank(bob);
        myToken.approve(alice, 10 ether);

        assertEq(myToken.allowance(bob, alice), 10 ether);

        vm.prank(alice);
        myToken.transferFrom(bob, john, 5 ether);

        assertEq(myToken.allowance(bob, alice), 5 ether);

        assertEq(myToken.balanceOf(bob), 95 ether);
        assertEq(myToken.balanceOf(alice), 0 ether);
        assertEq(myToken.balanceOf(john), 5 ether);
    }
}
