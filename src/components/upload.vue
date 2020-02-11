<template lang="pug">
    v-container
        v-card
            v-card-title Upload
            v-card
                v-file-input(
                    show-size 
                    label="File input"
                    @change="uploadFile"
                    )

</template>
<script>
export default {
    data () {
        return {
            uploadfile: {}
        }
    },
    methods: {
        uploadFile () {
            console.log('upload', this.uploadfile)
        }
    }
}
</script>