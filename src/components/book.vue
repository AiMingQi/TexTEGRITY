<template lang="pug">
    v-container
        //- v-card.mx-auto(light max-width="420px")
        //-     v-card-actions()
        //-         v-btn(@click="revealFeatured" block large color="orange") Reveal Featured
        v-card.mx-auto.pa-3(max-width="420" )
            v-img.white--text.align-end(
                height="400px"
                :src="bookCoverImageUrl"
                position="top center"
                )
            v-btn(
                color="orange"
                text
                block
                large
                @click="buyBook"
                ) Buy Book
            v-card-title.mt-3
                h2 {{bookTitle}}
            v-card-subtitle.pb-0.mb-3
                h3 By {{bookAuthor}}
                h4 Author's Ethereum Address: {{bookAuthorEthAddress}}
            v-card-text.text--primary
                div 
                    p {{bookDescription}}
                    p {{bookKeywords}}
            v-card-actions
                        v-btn(
                            color="green"
                            href="https://pepo.com/"
                            target="_blank"
                            rel="noopener"
                            text
                            ) Share
               
            
</template>

<script>
import web3 from "../web3"
import abi from '../contracts/TexTEGRITY.json';
import {store} from '../store'

export default {
    props: ['bookAddress'],
    data () {
        return {
            bookID: null,
            bookTitle: "ETH Denver 2020",
            bookCoverImageUrl: "http://ipfs.io/ipfs/QmcWfefEnW6o2iEZ4BUShb1yqt7tCjKVKEZ1zNiZCzkrcH",
            bookDescription: "Quietly changing the world. This is an awesome exploration of the ways in which ETH Denver completely reshaped the entire world.  By empowering Buidlers from all over the world to come together to create new decentralized brilliance.",
            bookKeywords: "#Buidl #Ethereum",
            bookAuthor: "The Pegabuffacorn",
            authorEthAddress: "",
            bookAuthorEthAddress: "",
            store        
        }
    },
    created () {
        this.getFeaturedFromETH()
    },
    methods: {
        buyBook () {
            alert("Sign your Transaction to Unlock digital download")
        },
        revealFeatured () {
            this.store.selectedContractAddress = this.store.FeaturedContractAddress
            this.getFeaturedFromETH();
        },
        async getFeaturedFromETH () {
            const address = this.bookAddress// Your account address goes here
            console.log("Getting batch at address: " + address);
            var randomString = await new web3.eth.Contract(abi, address);
            var returnedString = await randomString.methods.get().call();
            this.returnedString = returnedString
            const bookListing = JSON.parse(returnedString)
            
            this.bookID = bookListing.bookID
            this.bookTitle = bookListing.title
            this.bookCoverImageUrl = bookListing.img
            this.bookDescription = bookListing.description
            this.bookKeywords = bookListing.keywords
            this.bookPrice = bookListing.price
            this.bookAuthor = bookListing.author
            this.bookAuthorEthAddress = bookListing.authorEthAddress

            console.log("Returned from Ethereum", bookListing)
            // return newBatch;
            // let getString = await ContractTasks.Get(g_Web3, address);  
            // console.log("String from Ethereum", getString)
        },
        // async setMessageToETH () {
        //     const address = "0x32f7283006d3D025ddFfAe645312d15eBaAF0Bbc" // Your account address goes here
        //     console.log("Getting batch at address: " + address);
        //     var randomString = await new web3.eth.Contract(abi, address);
        //     // var returnedString = await randomString.methods.set("Testing").call();
        //     var TokenSuccess = await randomString.methods.set(JSON.stringify(this.listingStuffJson)).send({ gasLimit: "1000000",  from: this.store.OWNER_ADDRESS });
        //     // this.returnedString = returnedString
        //     // this.currentEthImageUrl = TokenSuccess
        //     console.log("Set To Ethereum Success", TokenSuccess)
        //     // return newBatch;
        //     // let getString = await ContractTasks.Get(g_Web3, address);  
        //     // console.log("String from Ethereum", getString)
        // }
    }
}
</script>