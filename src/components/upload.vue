<template lang="pug">
    v-container
        v-card
            v-card-title Author Upload
            v-card.pa-2
                p {{now}}
                v-file-input(
                    show-size 
                    label="Book Cover"
                    accept=".png,.jpg"
                    v-model="bookCoverImg"
                    )
                div.mx-auto
                    v-btn.mx-3(@click="uploadBookCover") Book Cover Upload
                    v-btn.mx-3(@click="bookImgUploadIpfs") Send to IPFS
                    p IPFS Hash: {{bookImgHash}}
                    v-img(:src="bookImgHashUrl" v-if="bookImgHashUrl")
                    a(:href="bookImgHashUrl" download target="_blank") Link
                v-text-field(
                    v-model="bookTitle"
                    label="Title"
                    )
                v-textarea(
                    v-model="bookDescription"
                    label="Description"
                )
                v-text-field(
                    v-model="bookKeywords"
                    label="Keywords"
                    )
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
export default {
    data () {
        return {
            file: null,
            selectedFile: null,
            fileBuffer: null,
            fileHash: null,
            fileHashUrl: null,
            bookTitle: 'Untitled',
            bookCoverImg: null,
            bookImgHash: null,
            bookImgHashUrl: null,
            bookDescription: 'Needs Descriptions',
            bookKeywords: "#Pegabuffacorn",
            bookListing: {
                img: this.bookImgHashUrl,
                title: this.bookTitle,
                description: this.bookDescription
            }
        }
    },
    methods: {
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
        createJson () {
            // const data = JSON.stringify(this.arr)
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
            return Date.now()
        } 
    }
}
</script>