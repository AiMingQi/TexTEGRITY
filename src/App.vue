<template>
  <v-app id="inspire">
    <v-navigation-drawer
      v-model="drawer"
      app
      clipped
    >
      <v-img class="mx-auto mt-5" src="https://ipfs.io/ipfs/QmP3Gb6zmUtA4JGMbvBNzK2PXaRQUagbRdPWTNVQCo5due" max-width="180px" contain></v-img>
      <v-list dense>
        <v-list-item
          v-for="item in items"
          :key="item.text"
          :href="item.link"
          target="_blank"
          rel="noopener"
        >
          <v-list-item-action >
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>
              {{ item.text }}
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-subheader class="mt-4 grey--text text--darken-1">AUTHORS</v-subheader>
        <v-list>
          <v-list-item
            v-for="item in items2"
            :key="item.text"
            link
          >
            <v-list-item-avatar>
              <img
                :src="`https://randomuser.me/api/portraits/men/${item.picture}.jpg`"
                alt=""
              >
            </v-list-item-avatar>
            <v-list-item-title v-text="item.text" />
          </v-list-item>
        </v-list>
        <v-list-item
          class="mt-4"
          link
        >
          <v-list-item-action>
            <v-icon color="grey darken-1">mdi-plus-circle-outline</v-icon>
          </v-list-item-action>
          <v-list-item-title class="grey--text text--darken-1">Add Your Book</v-list-item-title>
        </v-list-item>
        <v-list-item link>
          <v-list-item-action>
            <v-icon color="grey darken-1">mdi-settings</v-icon>
          </v-list-item-action>
          <v-list-item-title class="grey--text text--darken-1">Manage Subscriptions</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar
      app
      clipped-left
      color="#c00000"
      dense
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title class="mr-12 align-left">
        
        <span class="title">TexTEGRITY</span>
        <!-- <span>{{web3account}}</span> -->
      </v-toolbar-title>
      <v-spacer />
      <v-row
        align="center"
        style="max-width: 650px"
      >
        <v-text-field
          :append-icon-cb="() => {}"
          placeholder="Input Author Contract..."
          single-line
          append-icon="search"
          color="white"
          hide-details
        />
      </v-row>
    </v-app-bar>

    <v-content>
      <v-container>
         <v-row no-gutters>
            <v-col cols="4">
              <h2>Featured</h2>
              <book :bookAddress="this.store.FeaturedContractAddress"></book>
            </v-col>
            <v-col cols="4">
              <h2>Current Resident Author</h2>
              <book :bookAddress="this.store.AuthorContractAddress"></book>
            </v-col>
            <v-col cols="4">
              <h2>Upcoming Game Changer</h2>
              <book :bookAddress="this.store.GameChangerContractAddress"></book>
            </v-col>
          </v-row>
        </v-container>      
      
      <upload></upload>
      <box :address="OWNER_ADDRESS"></box>
    </v-content>
  </v-app>
</template>

<script>
import book from "./components/book.vue"
import upload from "./components/upload.vue"
import box from "./components/3box.vue"
import web3 from "./web3"
import {store} from './store'


  export default {
    components: { 
      book,
      upload,
      box,
    },
    props: {
      source: String,
    },
    data: () => ({
      FeaturedBook: '',
      AuthorBook: '',
      drawer: null,
      items: [
        { icon: 'home', text: 'Home' },
        { icon: 'trending_up', text: 'Most Popular' },
        { icon: 'featured_play_list', text: 'ETH Denver 2020', link: "https://ethdenver.com" },
      ],
      items2: [
        { picture: 28, text: 'Vitalik' },
        { picture: 38, text: 'Andreas' },
        { picture: 48, text: 'Joseph' },
        { picture: 58, text: 'Charles' },
        { picture: 78, text: 'Vlad' },
      ],
      OWNER_ADDRESS: null,
      store
    }),
    created () {
      console.log(process.env.VUE_APP_FIREBASE_CONFIG_SUCCESS1)
      this.$vuetify.theme.dark = true
      this.web3account = web3.eth.getAccounts((error, accounts) => {
                console.log(accounts);
                console.log('Web3 Capable Account Found');
                // this.OWNER_ADDRESS = accounts[0]
                this.store.OWNER_ADDRESS = accounts[0];
                this.grabbingAddress = false;
            });
      console.log("What is our web3 address?",this.web3account)
    },
    methods: {
      revealFeatured () {
        this.FeaturedBook = this.store.FeaturedContractAddress
      },
      revealAuthor () {

      }
    }
  }
</script>