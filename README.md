# Euler Attack Simulation (SimpleLending)

This project is an educational simulation of the Euler Finance attack (March 2023). It demonstrates how a missing health check in a lending protocol can be exploited to drain funds.

## How the attack works

1. Attacker deposits ETH as collateral.
2. Attacker takes a loan (5 ETH).
3. Attacker calls `donateToReserves` multiple times to reduce collateral below the liquidation threshold.
4. Attacker liquidates their own position, clearing debt and collateral.

## Contracts

- `SimpleLending.sol` – a simplified lending protocol with a vulnerability.
- `Attacker.sol` – executes the attack.

## How to run

1. Open Remix IDE (use Shanghai EVM version).
2. Deploy `SimpleLending.sol`.
3. Deploy `Attacker.sol` with the address of `SimpleLending`.
4. Run the attack steps:

| Step | Function | Value |
|------|----------|-------|
| 1 | `depositCollateral()` | 10 ETH |
| 2 | `takeLoan(5 ether)` | – |
| 3 | `donate(6 ether)` | – |
| 4 | `donate(4 ether)` | – |
| 5 | `liquidateSelf()` | – |

## Vulnerabilities exploited

- Missing health check in `donateToReserves`
- Ability to create artificial bad debt
- Flawed liquidation logic

## Lessons learned

- Always validate health changes before modifying collateral.
- Contracts that receive ETH must implement `receive()`.
- Donation functions must check if the position remains healthy after the operation.

## Author
A. K. Piotrowski 

## License

MIT
