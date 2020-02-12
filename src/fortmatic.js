import Fortmatic from "fortmatic"
import Web3 from 'web3'

const fm = new Fortmatic('pk_test_9EE372C86CDD5C46');
window.web3 = new Web3(fm.getProvider());

export default web3;