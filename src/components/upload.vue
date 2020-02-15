<template lang="pug">
    v-container
        v-card
            v-card-title 
                h2 Author Upload
            v-card.pa-5
                p {{now}}
                v-card.pa-5(light)
                    h3 Step 1 - Upload Book Cover Image to IPFS (.png or .jpg)- Max size 1MB
                    v-file-input(
                        show-size 
                        label="Book Cover"
                        accept=".png,.jpg"
                        v-model="bookCoverImg"
                        )
                    div.mx-auto.pa-5
                        v-btn.mx-3(@click="uploadBookCover") Book Cover Upload
                        v-btn.mx-3(@click="bookImgUploadIpfs") Send to IPFS
                        p.mt-3 Book Cover IPFS Hash: {{bookImgHash}}
                        v-img.mx-auto(:src="bookImgHashUrl" v-if="bookImgHashUrl" max-width="600px")
                        a(:href="bookImgHashUrl" download target="_blank") Link
                v-card.pa-5
                    v-card-title
                        h2 Book Listing Details
                    v-text-field(
                        v-model="bookTitle"
                        label="Title"
                        )
                    v-text-field(
                        v-model="bookAuthor"
                        label="Author"
                        )
                    v-text-field(
                        v-model="bookPrice"
                        label="Price"
                        prefix="$"
                        )
                    v-textarea(
                        v-model="bookDescription"
                        label="Description"
                        :rules="rules"
                        counter="360"
                    )
                    v-text-field(
                        v-model="bookKeywords"
                        label="Keywords"
                        )
                    v-text-field(
                        v-model="amazonReferralLink"
                        label="Amazon Referral Link"
                        )
                    v-card-actions.mx-auto
                        v-btn(@click="createJson") Create JSON
                v-card(light)
                    v-card-title
                        h2 Buy Slots
                    v-card-text
                    v-card-actions
                        v-btn(@click="buyFeaturedSlot") Buy Featured Slot
                        v-btn(@click="buyAuthorSlot") Buy Author Slot
                        v-btn(@click="buyGameChangerSlot") Buy Game Changer Slot
                        v-btn(@click="bookListingUploadIpfs") Send JSON to IPFS
                    v-card-text
                        p {{listingStuffJson}}
                        //- p Listing IPFS Hash: {{listingJsonHash}}
                        //- a(:href="listingJsonHashUrl" download target="_blank") Link
                    //- v-card.pa-5.ma-5(light)
                    //-     v-btn(@click="getMessageFromETH") Get Current Featured
                    //-     p.mt-3 This image is coming from a Smart Contract on Ethereum from IPFS
                    //-     span.blue--text.ml-5 {{returnedJson}}
                        
                //- v-file-input(
                //-     show-size 
                //-     label="File input"
                //-     v-model="file"
                //-     )v-btn.mx-3(@click="uploadFile") Create Buffer
                //- div.mx-auto
                //-     v-btn.mx-3(@click="uploadFile") Create Buffer
                //-     v-btn.mx-3(@click="encryptFile") Encrypt File
                //-     v-btn.mx-3(@click="ipfsUpload") Send to IPFS
                //-     p {{fileHash}}
                //-     p {{fileHashUrl}}
                //-     a(:href="fileHashUrl" download target="_blank") Link
                    

</template>
<script>
import ipfs from '../ipfs'
import moment from 'moment'
import axios from 'axios'
import web3 from '../web3'
import abi from '../contracts/TexTEGRITY.json';
import {store} from '../store'

export default {
    data () {
        return {
            rules: [v => v.length <= 360 || 'Max 360 characters'],
            file: null,
            selectedFile: null,
            fileBuffer: null,
            listingJsonString: null,
            listingJsonHash: null,
            listingJsonHashUrl: null,
            fileHash: null,
            fileHashUrl: null,
            bookTitle: 'Wrecklessly Absurd',
            bookAuthor: 'Chance JJ Edric',
            bookPrice: 13.99,
            bookCoverImg: null,
            bookImgHash: null,
            bookImgHashUrl: null,
            bookDescription: 'This book will continue what the first started. The last book was a collection of all the crazy stories in my life. I tried to not only make sense of the absurd, but also to hopefully give my kids, and you, an alternate perspective on life. These are true stories from my life infused with some twists and turns that happen to each and every one of us. Daily.',
            bookKeywords: "#Pegabuffacorn #ChanceEncounters",
            returnedString: "",
            returnedJson: {},
            currentEthImageUrl: "",
            amazonReferralLink: "",
            listingStuffJson: {
                
            },
            store
        }
    },
    methods: {
        // GetBatch: async (web3,address) => {
        //     console.log("Getting batch at address: " + address);
        //     var newBatch = await new web3.eth.Contract(Batch.abi, address);
        //     return newBatch;
        // },
        // async getMessageFromETH () {
        //     const address = "0x32f7283006d3D025ddFfAe645312d15eBaAF0Bbc" // Your account address goes here
        //     console.log("Getting batch at address: " + address);
        //     var randomString = await new web3.eth.Contract(abi, address);
        //     var returnedString = await randomString.methods.get().call();
        //     this.returnedString = returnedString
        //     this.returnedJson = JSON.parse(returnedString)
        //     console.log("Returned from Ethereum",returnedString)
        //     // return newBatch;
        //     // let getString = await ContractTasks.Get(g_Web3, address);  
        //     // console.log("String from Ethereum", getString)
        // },
        buyFeaturedSlot () {
            this.store.selectedContractAddress = this.store.FeaturedContractAddress
            this.sendListingToETH();
        },
        buyAuthorSlot () {
            this.store.selectedContractAddress = this.store.AuthorContractAddress
            this.sendListingToETH();
        },
        buyGameChangerSlot () {
            this.store.selectedContractAddress = this.store.GameChangerContractAddress
            this.sendListingToETH();
        },
        async sendListingToETH () {
            const address = this.store.selectedContractAddress // Your account address goes here
            console.log("Getting batch at address: " + address);
            var randomString = await new web3.eth.Contract(abi, address);
            // var returnedString = await randomString.methods.set("Testing").call();
            var TokenSuccess = await randomString.methods.set(JSON.stringify(this.listingStuffJson)).send({ gasLimit: "1000000",  from: this.store.OWNER_ADDRESS });
            // this.returnedString = returnedString
            // this.currentEthImageUrl = TokenSuccess
            console.log("Set To Ethereum Success", TokenSuccess)
            // return newBatch;
            // let getString = await ContractTasks.Get(g_Web3, address);  
            // console.log("String from Ethereum", getString)
        },
        createJson () {
            let listingStuff = {
                "bookID": this.rawNow,
                "img": this.bookImgHashUrl,
                "title": this.bookTitle,
                "price": this.bookPrice,
                "description": this.bookDescription,
                "keywords": this.bookKeywords,
                "author": this.bookAuthor,
                "authorEthAddress": this.store.OWNER_ADDRESS,
                "amazonReferralLink": this.amazonReferralLink
            }
            this.listingStuffJson = listingStuff
            // console.log("Book Listing", listingStuff)
            // const listingJson = JSON.stringify(listingStuff)
            // console.log(listingJson)
            // this.listingJsonString = listingJson
            // return listingJson;
        },
        selectFile (event) {
            this.selectedFile = event
            
        },
        // uploadFile () {
        //     const reader = new FileReader;
        //     reader.readAsArrayBuffer(this.file);
        //     console.log("Buffering...", this.file)
        //     reader.onloadend = () => {
        //         this.fileBuffer = Buffer(reader.result)
        //         // var arrayBuffer = reader.result;
        //         // this.fileBuffer = new Uint8Array(arrayBuffer);
        //     console.log("Buffer: ", this.fileBuffer);
        //     }
        // },
        uploadBookCover () {
            const reader = new FileReader;
            reader.readAsArrayBuffer(this.bookCoverImg);
            console.log("Buffering...", this.bookCoverImg)
            reader.onloadend = () => {
                this.bookImgBuffer = Buffer(reader.result)
                // var arrayBuffer = reader.result;
                // this.fileBuffer = new Uint8Array(arrayBuffer);
            console.log("Buffer: ", this.bookImgBuffer);
            this.bookImgUploadIpfs();
            }
        },
        encryptFile () {
            console.log('Encrypting...')
        },
        async bookImgUploadIpfs () {
            console.log("uploading Book Cover to IPFS....")
            ipfs.add(this.bookImgBuffer, (error, result) => {
                if (error || !result) {
                    console.log("Error!")
                    return;
                }
                else {
                    this.bookImgHash = result[0].hash
                    this.bookImgHashUrl = "http://ipfs.io/ipfs/" + this.bookImgHash
                    console.log("Book Cover Loaded to IPFS")
                    return;
                }
            })
        },
        async bookListingUploadIpfs () {
            console.log("Uploading...", this.listingStuffJson);
            const listJsonString = JSON.stringify(this.listingStuffJson)
            const buffer = Buffer.from(listJsonString)
            ipfs.add(buffer, {pin: true}, (error, result) => {
                if (error || !result) {
                    console.log("Error!")
                    return;
                }
                else {
                    this.listingJsonHash = result[0].hash
                    this.listingJsonHashUrl = "https://ipfs.io/ipfs/" + this.listingJsonHash
                    console.log("Listing Json Uploaded to IPFS!")
                    axios.get(this.listingJsonHashUrl)
                        .then(function (response) {
                            // handle success
                            console.log(response);
                        })
                        .catch(function (error) {
                            // handle error
                            console.log(error);
                        })
                    return;
                }
            });
        },
        async ipfsUpload () {
            console.log("Uploading...");
            ipfs.add(this.fileBuffer, (error, result) => {
                if (error || !result) {
                    console.log("Error!")
                    return;
                }
                else {
                    this.fileHash = result[0].hash
                    this.fileHashUrl = "http://ipfs.io/ipfs/" + this.fileHash
                    console.log("Success!")
                    return;
                }
            });
        }
            // console.log ('The File', this.file)
            // ipfs.files.add(Buffer.from(this.file), function(error, result) {
            //     if (error || !result) {
            //     console.log(error);
            //     }
            //     else {
            //     console.log("Success!");
            //     }
            // });
            // ipfs.files.add (this.file, (error, result) => {
            //     console.log('IPFS Result', result)
            //     if(error){
            //         console.error(error)
            //         return
            //     }
            // })
        
    },
    computed: {
        bookListingJSON: function () {

            const listingJson = JSON.stringify(this.arr)
            return listingJson
        },
        rawNow: function () {
            let now = Date.now()
            return now;
        },
        now: function () {
            let now = Date.now()
            let formatedNow = moment(now).format('MMMM Do YYYY, h:mm:ss a');
            return formatedNow;
        } 
    }
}
</script>