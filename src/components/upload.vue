<template lang="pug">
    v-container
        v-card
            v-card-title Author Upload
            v-card
                v-file-input(
                    show-size 
                    label="File input"
                    v-model="file"
                    )
                div.mx-auto
                    v-btn.mx-3(@click="uploadFile") Create Buffer
                    v-btn.mx-3(@click="encryptFile") Encrypt File
                    v-btn.mx-3(@click="ipfsUpload") Send to IPFS
                    p {{fileHash}}
                    p {{fileHashUrl}}
                    a(:href="fileHashUrl" download target="_blank") Link
                    

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

        }
    },
    methods: {
        selectFile (event) {
            this.selectedFile = event
            
        },
        uploadFile () {
            const reader = new FileReader;
            reader.readAsArrayBuffer(this.file);
            console.log("Buffering...", this.file)
            reader.onloadend = () => {
                this.fileBuffer = Buffer(reader.result)
                // var arrayBuffer = reader.result;
                // this.fileBuffer = new Uint8Array(arrayBuffer);
            console.log("Buffer: ", this.fileBuffer);
            }
        },
        encryptFile () {
            console.log('Encrypting...')
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
        
    }
}
</script>