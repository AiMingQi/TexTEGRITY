<template lang="pug">
    v-container
        v-card
            v-card-title
                h2 3Box is here
            v-card-text
                v-btn(@click="open3box") open 3Box
                p {{boxProfile.name}}
                p {{boxProfileImageUrl}}
                v-img(
                    :src="boxProfileImageUrl"
                    max-width="200px"
                    )
</template>

<script>
import Box from "3box"

export default {
    data () {
        return {
            box: "What is in the box?",
            address: "0xC1D54fEB9f13F88E3fD098a4205DBF0d952340F0",
            threadAddress: "0xc1d54feb9f13f88e3fd098a4205dbf0d952340f0",
            boxProfile: {
                name: 'Someone',
            },
            boxProfileImageUrl: "",
            boxSpaceList: {}
        }
    },
    methods: {
        async open3box () {
           const profile = await Box.getProfile(this.address)
           this.boxProfile = profile
           this.boxProfileImageUrl = "http://ipfs.io/ipfs/" + profile.image[0].contentUrl["/"]
           console.log(profile)
           const spaceList = await Box.listSpaces(this.address)
           this.boxSpaceList = spaceList
           console.log(spaceList)
        }
    }
}
</script>