const ipfsClient = require('ipfs-http-client')

// // connect to ipfs daemon API server
const ipfs = ipfsClient('http://127.0.0.1:8081') // (the default in Node.js)

// // or connect with multiaddr
// const ipfs = ipfsClient('/ip4/127.0.0.1/tcp/5001')

// or using options
// const ipfs = ipfsClient({ host: 'ipfs.infura.io', port: '5001', protocol: 'http' })

// // or specifying a specific API path
// const ipfs = ipfsClient({ host: '1.1.1.1', port: '80', apiPath: '/ipfs/api/v0' })

export default ipfs;