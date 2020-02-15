/* eslint-disable no-console */
import Web3 from 'web3';

// import Portis from '@portis/web3';

// const portis = new Portis('8f7a2d9f-af0e-42f5-889c-f1542aab0118', 'mainnet');
// const web3 = new Web3(portis.provider);

if (window.ethereum) {
  window.web3 = new Web3(ethereum);
  try {
    // Request account access if needed
    ethereum.enable();
  } catch (error) {
    // User denied account access...
  }
} else if (window.web3) {
  // Legacy dapp browsers...
  window.web3 = new Web3(web3.currentProvider);
} else {
    // const portis = new Portis('8f7a2d9f-af0e-42f5-889c-f1542aab0118', 'rinkeby');
    // window.web3 = new Web3(portis.provider);
    // // const rpcURL = new Web3.providers.HttpProvider('https://rinkeby.infura.io/v3/cfb3b8a701bb4f389604f99cb506097d')
    // window.web3 = new Web3(rpcURL)
  // Non-dapp browsers...
  console.log(
   'web3' + window.web3
  );
}
console.log(web3);
export default web3;