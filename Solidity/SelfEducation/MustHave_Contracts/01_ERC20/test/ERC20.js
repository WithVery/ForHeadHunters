const {expect} = require("chai");
const hre = require("hardhat");

describe("ERC20", function() {
  let owner
  let seller
  let spender
  let erc20Contract

  const ether = hre.ethers;

  beforeEach(async function() {
    [owner, seller, spender] = await ether.getSigners();

    const Erc20 = await ether.getContractFactory("ERC20");
    erc20Contract = await Erc20.deploy(100, "TheTestToken", "TTT");
    await erc20Contract.waitForDeployment();
    const ca = await erc20Contract.getAddress();
  })

  it("correct deployment", async function() {
    expect(await erc20Contract.getAddress()).to.be.a.properAddress;
  })

  it("correct amount", async function() {
    expect(await erc20Contract.totalSupply()).to.equal(100);
  })

  it("correct name", async function() {
    expect(await erc20Contract.name()).to.equal("TheTestToken");
  })

  it("correct symbol", async function() {
    expect(await erc20Contract.symbol()).to.equal("TTT");
  })

  it("correct decimals", async function() {
    expect(await erc20Contract.decimals()).to.equal(18);
  })

  it("correct balance of Owner", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
  })

  it("correct minting", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    expect(await erc20Contract.mint(100)).to.emit(erc20Contract, "Minted");
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(200);
  })

  it("correct no-an-owner minting handling", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    await expect(erc20Contract.connect(seller).mint(1)).to.be.revertedWith("not an owner");
  })

  it("correct burning", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    expect(await erc20Contract.burn(40)).to.emit(erc20Contract, "Burned");
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(60);
  })

  it("correct not-an-owner burning", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    await expect(erc20Contract.connect(seller).burn(40)).to.be.revertedWith("not an owner");
  })


  it("correct overburning handling", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    await expect(erc20Contract.burn(110)).to.be.reverted;
  })

  it("transfer", async function() {
    expect(await erc20Contract.balanceOf(owner.getAddress())).to.equal(100);
    const transfer = await erc20Contract.transfer(seller.getAddress(), 10);
    await transfer.wait();
    expect(await erc20Contract.balanceOf(seller.getAddress())).to.equal(10);

    // transfer to 0 address
    await expect(erc20Contract.transfer("0x0000000000000000000000000000000000000000", 10)).to.be.revertedWith("invalid address");
    // transfer to oneself 
    await expect(erc20Contract.transfer(owner.getAddress(), 10)).to.be.revertedWith("`from` == `to`");
  })

  it("allowances and transferFrom", async function() {
    expect(await erc20Contract.allowance(seller.getAddress(), spender.getAddress())).to.equal(0);
    // transfer to seller
    const transfer = await erc20Contract.transfer(seller.getAddress(), 10);
    await transfer.wait();
    expect(await erc20Contract.balanceOf(seller.getAddress())).to.equal(10);

    // allow to spender
    await expect(erc20Contract.connect(seller).approve(spender.getAddress(), 11)).to.be.revertedWith("not enough tokens");
    expect(await erc20Contract.connect(seller).approve(spender.getAddress(), 5)).to.emit(erc20Contract, "Approval");
    expect(await erc20Contract.allowance(seller.getAddress(), spender.getAddress())).to.equal(5);

    // transfer from 
    await expect(erc20Contract.connect(spender).transferFrom(seller.getAddress(), seller.getAddress(), 11)).to.be.revertedWith("`from` == `to`");
    await expect(erc20Contract.connect(spender).transferFrom(seller.getAddress(), "0x0000000000000000000000000000000000000000", 11)).to.be.revertedWith("invalid address");
    await expect(erc20Contract.connect(spender).transferFrom(seller.getAddress(), spender.getAddress(), 1)).not.to.be.reverted;


  })
})