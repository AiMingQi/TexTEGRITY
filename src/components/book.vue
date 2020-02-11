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
                            height="200"
                            @click="toggle"
                            )
                            v-img(src="http://ipfs.io/ipfs/Qmd88ordzwMSfiGmWio78q7cKBivm6VucE8Qjx9fKCx4ac")
                            v-scroll-y-transition
                                div.display-3.flex-grow-1.text-center(v-if="active")
                    v-btn(@click="open3box") 3box Test
                        
</template>

<script>
import Box from "3box"

export default {
    data () {
        return {
            title: "TexTEGRITY",
            address: "0xC1D54fEB9f13F88E3fD098a4205DBF0d952340F0",
            threadAddress: "0xc1d54feb9f13f88e3fd098a4205dbf0d952340f0"
        }
    },
    methods: {
        async open3box () {
           const profile = await Box.getProfile(this.address)
           console.log(profile)
           const spaceList = await Box.listSpaces(this.address)
           console.log(spaceList)
        }
    }
}
</script>