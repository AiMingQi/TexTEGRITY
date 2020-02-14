<template lang="pug">
    v-container
        v-card
            v-card-title
                h2 Textile
            v-card-actions
                v-btn(@click="getTextileUser") Get Textile User

</template>

<script>
import textile from "../textile"
import {store} from "../store"
export default {
    data () {
        return {
            store
        }
    },
    methods: {
        async getTextileUser () {
            const name = await textile.profile.name()
            console.log(name)
            console.log(textile)
        }
    }
}
</script>