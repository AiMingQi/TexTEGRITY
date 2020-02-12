<template lang="pug">
    v-card.mx-auto(max-width="400")
        v-img.white--text.align-end(
            height="300px"
            src="http://ipfs.io/ipfs/QmcWfefEnW6o2iEZ4BUShb1yqt7tCjKVKEZ1zNiZCzkrcH"
            position="top center"
            )
        v-btn(
            color="orange"
            text
            block
            large
            ) Buy Book
        v-card-title.mt-3
            h3 ETH Denver 2020 Book
        v-card-subtitle.pb-0.mb-3
            h4 A book about changing the world
        v-card-text.text--primary
            div 
                p This book is an awesome exploration of the ways in which ETH Denver completely reshaped the entire world.  By empowering Buidlers from all over the world to come together to create new decentralized brilliance.
                p #Pegabuffacorn
        v-card-actions
            v-btn(
                color="green"
                href="https://pepo.com/"
                target="_blank"
                rel="noopener"
                text
                ) Share
            //- v-btn(
            //-     color="blue"
            //-     text
            //-     ) Explore
            
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