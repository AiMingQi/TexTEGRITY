import Fortmatic from 'fortmatic';
// Works for web3 1.0 and pre-1.0 versions
import Web3 from 'web3';

//const fm = new Fortmatic(process.env.YOUR_API_KEY);
const fm = new Fortmatic('pk_test_240F825CDF1CAB47');
window.web3 = new Web3(fm.getProvider());
