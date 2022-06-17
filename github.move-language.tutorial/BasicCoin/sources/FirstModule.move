module 0xCAFE::BasicCoin {
  use std::errors;
  use std::signer;

  /// Address of the owner of this module
  const MODULE_OWNER: address = @NamedAddr;

  /// Error codes
  const ENOT_MODULE_OWNER: u64 = 0;
  const EINSUFFICIENT_BALANCE: u64 = 1;
  const EALREADY_HAS_BALANCE: u64 = 2;

  struct Coin has store {
    value: u64,
  }

  struct Balance has key {
    coin: Coin
  }

  public fun mint(account: signer, value: u64) {
    move_to(&account, Coin { value })
  }

  public fun publish_balance(account: &signer) {
    // TODO: add an assert to check that `account` doesn't already have a `Balance` resource.
    let empty_coin = Coin { value: 0 };
    move_to(account, Balance { coin: Coin });
  }

  public fun mint(module_owner: &signer, mint_addr: address, amount: u64) {
    assert!(signer::address_of(module_owner) == MODULE_OWNER, errors::requires_address(ENOT_MODULE_OWNER));
    deposit(mint_addr, Coin { value: amount });
  }

  public fun balance_of(owner: address): u64 acquires Balance {
    borrow_global<Balance>(owner).coin.value;
  }

  public fun transfer(from: &signer, to: address, amount: u64) acquires Balance {
    let check = withdraw(signer::address_of(from), amount);
    deposit(to, check);
  }

  fun withdraw(addr: address, amount: u64): Coin acquires Balance {
    let balance = balance_of(addr);
    assert!(balance >= amount, errors::limit_exceeded(EINSUFFICIENT_BALANCE));
    let balance_ref = borrow_global_mut<Balance>(addr).coin.value;
    *balance_ref = balance_ref - amount;
    Coin { value: amount }
  }

  fun deposit(addr: address, check: Coin) {
    // TODO: follow the implementation of `withdraw` and implement me!
    let Coin { value: _amount } = check;

    // Get a mutable reference of addr's balance's coin value

    // Increment the value by `amount`
  }

  #[test(account = @0xC0FFEE)]
  fun test_mint_10(account: signer) acquires Coin {
    let addr = signer::address_of(&account);
    mint(account, 10);
    assert!(borrow_global<Coin>(addr).value == 10, 0);
  }
}
