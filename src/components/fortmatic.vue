<template lang="pug">
    v-container
        v-card
            v-card-actions 
                v-btn(@click="checkFm") Check Fm 
            v-card-title    
                p web3 provided by: {{fm.currentProvider.fortmaticClient}}

</template>
<script>
import fm from '../fortmatic'
export default {
    data () {
        return {
            fm: {
                currentProvider: {
                    fortmaticClient: "Press Check Fm to acquire..."
                }
            },
        }
    },
    methods: {
        checkFm () {
            this.fm = fm
            console.log(fm)
        }
    }
}
</script>