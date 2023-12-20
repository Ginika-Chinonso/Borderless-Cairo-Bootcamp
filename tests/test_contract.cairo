use starknet::{ContractAddress, contract_address_const};

use snforge_std::{declare, ContractClassTrait, cheatcodes::{start_prank, CheatTarget}};

use cairobootcamp::{IBorderlessTraitDispatcher, IBorderlessTraitDispatcherTrait};

fn deploy_contract(name: felt252, address: ContractAddress) -> ContractAddress {
    let contract = declare(name);
    let mut call_data = ArrayTrait::new();
    call_data.append(address.into());
    contract.deploy(@call_data).unwrap()
}

#[test]
fn test_deployment() {
    let owner_address = contract_address_const::<'owner'>();

    let contract_address = deploy_contract('Borderless', owner_address);

    let contract = IBorderlessTraitDispatcher { contract_address };

    assert(contract.get_owner() == owner_address, 'Wrong owner');
}

#[test]
fn test_set_name() {
    let owner_address = contract_address_const::<'owner'>();

    let contract_address = deploy_contract('Borderless', owner_address);

    let contract = IBorderlessTraitDispatcher { contract_address };

    let addr = contract_address_const::<'User'>();

    start_prank(CheatTarget::One(contract_address), addr);

    contract.set_name('Borderless');

    assert(contract.get_name(addr) == 'Borderless', 'Wrong name set');

}
