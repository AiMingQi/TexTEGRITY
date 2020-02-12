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
                v-btn(@click="createSpace") Create Space
                v-btn(@click="getPosts") Get Posts
</template>

<script>
import Box from "../box"
import {store} from '../store'

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
            boxSpaceList: {},
            store
        }
    },
    methods: {
        async open3box () {
           const profile = await Box.getProfile(this.store.OWNER_ADDRESS)
           this.boxProfile = profile
           this.boxProfileImageUrl = "http://ipfs.io/ipfs/" + profile.image[0].contentUrl["/"]
           console.log("3Box Profile", profile)
           const spaceList = await Box.listSpaces(this.address)
           this.boxSpaceList = spaceList
           console.log("Space List", spaceList)
           const spaceData = await Box.getSpace(this.address)
           this.boxSpaceData = spaceData
           console.log("Space Data", spaceData)
        },
        async createSpace () {
            const openBox = await Box.openBox(this.store.OWNER_ADDRESS, window.ethereum)
            console.log(openBox)
            
        },
        async getPosts () {
            const posts = await Box.getThreadByAddress(this.store.OWNER_ADDRESS)
            console.log(posts)
        },
        // async setBoxStorage () {
        //     const boxStorage = await space.public.set('Book Name', 'Something Great')
        //     console.log(boxStorage)
        // }
        // async openSpace () {
        //     const space = await Box.openSpace('TexTEGRITY')
        //     console.log("See Space", space)
        // }
    }
}
</script>