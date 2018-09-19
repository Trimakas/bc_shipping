<template>
  <v-app>
    <v-container text-xs-center >
      <v-layout row wrap align-center>

        <v-flex xs1 class="text-xs-left mx-auto my-5">
          <v-spacer class="mt-5"></v-spacer>
          <v-btn outline fab dark large color="indigo" class="mt-5" @click="sendToStepOne">
            <v-icon dark size="60px" class="my_dark_purple_text">chevron_left</v-icon>
          </v-btn>
        </v-flex>        
        
        <v-flex xs6>
          <h1 class="display-1 sans_pro_medium my_dark_purple_text my-4">FBA Shipping</h1>
          <div class="dot mx-2 mt-3"></div>
          <div class="filled_dot mx-2"></div>
          <div class="dot mx-2"></div>
          <v-spacer></v-spacer>
            <v-card>
              <v-card-text class="sans_pro card_text_fix">
                Our service is completely free! All we will need is developer access to your Amazon seller account.
                Don't worry, it shouldn't take more than a minute, and we have detailed video instructions on the next page.
              </v-card-text>
            </v-card>
        </v-flex>
        
        <v-flex xs1 class="text-xs-right mx-auto my-5">
          <v-spacer class="mt-5"></v-spacer>
          <v-btn outline fab dark large color="indigo" class="mt-5" @click="sendToAmazonCreds">
            <v-icon dark size="60px" class="my_dark_purple_text">chevron_right</v-icon>
          </v-btn>
        </v-flex>
        
      </v-layout>
    </v-container>
  </v-app>  
</template>

<script>
import {dataShare} from '../packs/application.js';
import axios from 'axios';

export default {
  data: function() {
    return {
      whereToGoForward: "amazon_credentials",
      whereToGoBack: "one",      
      button_text_large: "Check if you have carrier calculated shipping",
      button_text_medium: "Check for carrier calculated shipping",
      button_text_small: "Check for C.C. shipping",
      icon_size: "",
      which_to_show: "button",
      show_warning: ""
    }
  },
  computed: {
    iconSize() {
      if(this.$vuetify.breakpoint.mdAndUp){
        this.icon_size = "60px";
        return this.icon_size;
      }
      else if (this.$vuetify.breakpoint.sm) {
        this.icon_size = "40px";
        return this.icon_size;
      } 
      else{
        this.icon_size = "0px";
        return this.icon_size;
      } 
    },
    buttonSize() {
      if(this.$vuetify.breakpoint.mdAndUp){
        return true;
      }
      else {
        return false;
      } 
    },
    size() {
      console.log("the screen size is " + this.$vuetify.breakpoint.name);
    },
    buttonText() {
      if(this.$vuetify.breakpoint.lgAndUp){
        return this.button_text_large;
      }
      else if(this.$vuetify.breakpoint.md) {
        return this.button_text_medium;
      }
      else {
        return this.button_text_small;
      }
    }
  },
  methods: {
    sendToStepOne() {
      dataShare.$emit('whereToGo', this.whereToGoBack);
    },
    sendToAmazonCreds() {
      dataShare.$emit('whereToGo', this.whereToGoForward);
    }
  },
};  
</script>

<style>

.bold {
  font-weight: bold !important;
}  
  
</style>