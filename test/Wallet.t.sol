// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;
    address public owner;
    address public nonOwner;

    function setUp() public {
        owner = address(this); // Adres testującego
        nonOwner = vm.addr(1); // Losowy adres (tworzony przez Foundry)
        wallet = new Wallet(); // Tworzymy nową instancję kontraktu Wallet
    }

    function testDeposit() public {
        // Symulacja wpłaty 1 ether
        vm.deal(address(this), 1 ether); // Przyznanie 1 ether na ten adres
        wallet.deposit{value: 1 ether}();
        assertEq(wallet.viewBalance(), 1 ether);
    }

    function testWithdrawByOwner() public {
        // Przygotowanie: wpłata 1 ether
        vm.deal(address(this), 1 ether);
        wallet.deposit{value: 1 ether}();

        // Wypłata przez właściciela
        uint256 initialBalance = address(this).balance;
        wallet.withdraw(0.5 ether);

        // Sprawdzamy, czy balans właściciela wzrósł
        assertEq(address(this).balance, initialBalance + 0.5 ether);
        // Sprawdzamy, czy balans kontraktu się zmniejszył
        assertEq(wallet.viewBalance(), 0.5 ether);
    }

    function testWithdrawByNonOwner() public {
        // Przygotowanie: wpłata 1 ether
        vm.deal(address(this), 1 ether);
        wallet.deposit{value: 1 ether}();

        // Próba wypłaty przez nie-właściciela
        vm.prank(nonOwner); // Symulacja działania w imieniu `nonOwner`
        vm.expectRevert("Only the owner can withdraw");
        wallet.withdraw(0.5 ether);
    }

    function testWithdrawMoreThanBalance() public {
        // Przygotowanie: wpłata 0.5 ether
        vm.deal(address(this), 1 ether);
        wallet.deposit{value: 0.5 ether}();

        // Próba wypłaty większej kwoty niż dostępny balans
        vm.expectRevert("Not enough Ether in the wallet");
        wallet.withdraw(1 ether);
    }

    function testDirectReceive() public {
        // Symulacja wysłania Ether bezpośrednio na adres kontraktu
        vm.deal(address(this), 1 ether); // Przyznanie 1 ether
        (bool success, ) = address(wallet).call{value: 1 ether}("");
        assertTrue(success);
        assertEq(wallet.viewBalance(), 1 ether);
    }
}
