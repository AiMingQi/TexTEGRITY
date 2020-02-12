<template lang="pug">
    v-item-group
        v-container
            v-row
                v-col(
                    v-for="n in 3"
                    :key="n"
                    cols="12"
                    md="4"
                    )
                    v-item(v-slot:default="{ active, toggle }")
                        v-card(:color="active ? 'primary' : ''"
                            class="d-flex align-center"
                            dark
                            height="300"
                            @click="toggle"
                            )
                            v-card-title
                                h3 Book Title
                            v-card-text
                                v-img(src="http://ipfs.io/ipfs/Qmd88ordzwMSfiGmWio78q7cKBivm6VucE8Qjx9fKCx4ac")
                            v-scroll-y-transition
                                div.display-3.flex-grow-1.text-center(v-if="active")
                        
</template>

<script>


export default {
    data () {
        return {
            title: "TexTEGRITY",
            
        }
    },
    methods: {
        
    }
}
</script>