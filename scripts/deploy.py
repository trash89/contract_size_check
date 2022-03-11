from brownie import accounts, FailedAttack, Hack, Target, exceptions
import pytest


def main():
    print("Deploying Target...")
    t = Target.deploy({"from": accounts[0]})
    print(f"Target deployed at {t}")

    print("Deploying FailedAttack...")
    fa = FailedAttack.deploy({"from": accounts[0]})
    print(f"FailedAttack deployed at {fa}")

    with pytest.raises(exceptions.VirtualMachineError):
        print("Trying to call FailedAttack.pwn()...")
        tx = fa.pwn(t.address, {"from": accounts[0]})
        tx.wait(1)
        print("Called FailedAttack.pwn()")

    print("Deploying Hack with the address of Target...")
    h = Hack.deploy(t.address, {"from": accounts[0]})
    print(f"Hack deployed at {h}")
