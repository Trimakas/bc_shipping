<template>
    <v-container fluid grid-list-lg>
      <v-layout row wrap v-resize="getHeight">
        <v-flex xs12 text-xs-center>
          <h1 class="display-1 oswald my_dark_purple_text my-4">FBA Shipping</h1>
          <div class="dot mx-2 mt-3"></div>
          <div class="dot mx-2"></div>
          <div class="filled_dot mx-2"></div>
          <v-spacer></v-spacer>
          <h1 class="title mont bold fix-title-height">Provide your amazon credentials below and you're all set!</h1>
        </v-flex>
        
        <v-flex xs8>
          <v-card class="lightbeige" id="devIds">
            <v-card-title>
              <v-icon class="my_dark_purple_text">vpn_key</v-icon>
              <h1 class="title oswald my_dark_purple_text pl-2">DEVELOPMENT IDS</h1>
            </v-card-title>
            
            <v-layout row>
              <v-flex xs5 offset-xs1>
                <h1 class="subheading mont bold">US, Canada, Mexico</h1>
              </v-flex>
              <v-flex xs5>
                <h1 class="subheading mont bold">UK and the EU</h1>
              </v-flex>
            </v-layout>

            <v-layout row>
              <v-flex xs3 offset-xs1>
                <v-text-field disabled solo :value="us" class="active textfield-background-beige mont"></v-text-field>
              </v-flex>
              <v-flex xs2>
                <v-btn large class="my_dark_purple_btn match-to-text-field" @click="copyCreds(us)">Copy</v-btn>
              </v-flex>

              <v-flex xs3>
                <v-text-field disabled solo :value="eu" class="active textfield-background-beige mont"></v-text-field>
              </v-flex>
              <v-flex xs2>
                <v-btn large class="my_dark_purple_btn match-to-text-field" @click="copyCreds(eu)">Copy</v-btn>
              </v-flex>              
            </v-layout>
            
            <v-layout row>
              <v-flex xs5 offset-xs1>
                <h1 class="subheading mont bold">Australia</h1>
              </v-flex>
            </v-layout>
            
            <v-layout row>
              <v-flex xs3 offset-xs1>
                <v-text-field disabled solo :value="australia" class="active textfield-background-beige mont"></v-text-field>
              </v-flex>
              <v-flex xs2>
                <v-btn large class="my_dark_purple_btn match-to-text-field" @click="copyCreds(australia)">Copy</v-btn>
              </v-flex>
            </v-layout>
          
          </v-card>
        </v-flex>
        
        <v-flex xs4 text-xs-center>
          <v-card class="lightblue" :height="matchingHeights + 'px'">
            <a href="https://youtu.be/yO1MB2ed6AM" target="_blank"><img src="how.png" class="pt-5"/></a>
            <v-card-text class="mont card_text_fix">
                  Do I retrieve my Amazon credentials?
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
</template>        

<script>

import {dataShare} from '../packs/application.js';
import axios from 'axios';

export default {
  data: function() {
    return {
      australia: "6078-0648-3237",
      us: "7531-9706-4825",
      eu: "4048-6340-0484",
      matchingHeights: 295
    };
  },
  methods: {
    getHeight() {
      var devCard = document.getElementById("devIds");
      this.matchingHeights = devCard.offsetHeight;
    },
    copyCreds(country) {
      this.$clipboard(country);
    }
  }
};

</script>

<style scoped>

.fix-title-height {
  line-height: 1.25 !important;
}

.fixHeight {
  min-height: 1vh !important; 
}

</style>