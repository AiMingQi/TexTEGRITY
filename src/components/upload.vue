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
                v-btn(@click="uploadFile") Create Buffer
                v-btn(@click="ipfsUpload") Send to IPFS

</template>
<script>
import ipfs from '../ipfs'
export default {
    data () {
        return {
            file: null,
            selectedFile: null,
            fileBuffer: null
        }
    },
    methods: {
        selectFile (event) {
            this.selectedFile = event
            
        },
        uploadFile () {
             const reader = new FileReader;
                reader.readAsArrayBuffer(this.file);
                console.log("Buffering...")
                reader.onload = function() {
                    var arrayBuffer = reader.result;
                    this.fileBuffer = new Uint8Array(arrayBuffer);
                    console.log("Buffer: ", this.fileBuffer);
                }
        },
        async ipfsUpload () {
            console.log("Uploading...");
            ipfs.add(this.fileBuffer, (error, result) => {
                if (error || !result) {
                console.log("Error!");
                }
                else {
                console.log("Success!");
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