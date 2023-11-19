const { expect } = require("chai");
const hre = require("hardhat");

describe("Greeter", function() {
  let owner
  let acc2 
  let greeter
  beforeEach(async function() {
    [owner, acc2] = await hre.ethers.getSigners()
    const Greeter = await hre.ethers.getContractFactory("Greeter");
    greeter = await Greeter.deploy("Hey!")
    await greeter.waitForDeployment()
    console.log(greeter.address)
  })

  it("correct setup", async function() {
    expect(await greeter.owner()).to.equal(owner.address);
    expect(await greeter.getGreeting()).to.equal("Hey!");
  })

  it("correct initial greeting", async function() {
    expect(await greeter.getGreeting()).to.equal("Hey!");
  })

  it("Another greeting", async function() {
    const tx = await greeter.connect(acc2).greetMe("Hi!")
    await tx.wait();

    expect(await greeter.getGreeting()).to.equal("Hi!");
    expect(await greeter.lastGreeter()).to.equal(acc2.address);
  })

})
