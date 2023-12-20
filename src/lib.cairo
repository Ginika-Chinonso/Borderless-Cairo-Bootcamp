use starknet::ContractAddress;

#[starknet::interface]
trait IBorderlessTrait<TContractState> {
    fn get_owner(self: @TContractState) -> ContractAddress;
    fn get_name(self: @TContractState, address: ContractAddress) -> felt252;
    fn set_name(ref self: TContractState, name: felt252);
}


#[starknet::contract]
mod Borderless {
    use super::{IBorderlessTrait, IBorderlessTraitDispatcherTrait};
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        address_to_name: LegacyMap<ContractAddress, felt252>,
        is_used: LegacyMap<felt252, bool>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, address: ContractAddress) {
        self.owner.write(address);
    }

    #[external(v0)]
    impl Borderless of IBorderlessTrait<ContractState> {

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn get_name(self: @ContractState, address: ContractAddress) -> felt252 {
            self.address_to_name.read(address)
        }

        fn set_name(ref self: ContractState, name: felt252) {
            assert(!self.is_used.read(name), 'Name already used');
            let caller_address = get_caller_address();
            self.address_to_name.write(caller_address, name);
            self.is_used.write(name, true);
        }

    }
}