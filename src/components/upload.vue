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
                        v-model="bookPrice"
                        label="Price"
                        prefix="$"
                        )
                    v-textarea(
                        v-model="bookDescription"
                        label="Description"
                    )
                    v-text-field(
                        v-model="bookKeywords"
                        label="Keywords"
                        )
                    v-card-actions.mx-auto
                        v-btn(@click="createJson") Create JSON
                        v-btn(@click="bookListingUploadIpfs") Send JSON to IPFS
                    div
                        v-btn(@click="writeToETH") Test Ethereum
                        p This message is coming from Ethereum {{returnedString}}
                    v-card-text
                        p {{listingStuffJson}}
                        p Listing IPFS Hash: {{listingJsonHash}}
                        a(:href="listingJsonHashUrl" download target="_blank") Link
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

export default {
    data () {
        return {
            file: null,
            selectedFile: null,
            fileBuffer: null,
            listingJsonString: null,
            listingJsonHash: null,
            listingJsonHashUrl: null,
            fileHash: null,
            fileHashUrl: null,
            bookTitle: 'Untitled',
            bookPrice: 0,
            bookCoverImg: null,
            bookImgHash: null,
            bookImgHashUrl: null,
            bookDescription: 'Needs Descriptions',
            bookKeywords: "#Pegabuffacorn",
            returnedString: "",
            listingStuffJson: {
                
            },
        }
    },
    methods: {
        // GetBatch: async (web3,address) => {
        //     console.log("Getting batch at address: " + address);
        //     var newBatch = await new web3.eth.Contract(Batch.abi, address);
        //     return newBatch;
        // },
        async writeToETH () {
            const address = "0x32f7283006d3D025ddFfAe645312d15eBaAF0Bbc" // Your account address goes here
            console.log("Getting batch at address: " + address);
            var randomString = await new web3.eth.Contract(abi, address);
            var returnedString = await randomString.methods.get().call();
            this.returnedString = returnedString
            console.log("Returned from Ethereum",returnedString)
            // return newBatch;
            // let getString = await ContractTasks.Get(g_Web3, address);  
            // console.log("String from Ethereum", getString)
        },
        createJson () {
            let listingStuff = {
                "img": this.bookImgHashUrl,
                "title": this.bookTitle,
                "price": this.bookPrice,
                "description": this.bookDescription,
                "keywords": this.bookKeywords
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
            ipfs.add(buffer, (error, result) => {
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
        now: function () {
            let now = Date.now()
            let formatedNow = moment(now).format('MMMM Do YYYY, h:mm:ss a');
            return formatedNow;
        } 
    }
}
</script>