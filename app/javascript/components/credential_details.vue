<template>
    <v-container fluid grid-list-lg class="come_closer">
      <v-layout row wrap>
        <v-flex xs12>
          <v-card class="lightpurple">
            <v-card-title>
              <v-icon class="my_dark_purple_text">language</v-icon>
              <h1 class="title oswald my_dark_purple_text pl-2 pr-5">ENTER YOUR AMAZON CREDENTIALS BELOW</h1>
            </v-card-title>
         
         <v-form ref="form" v-model="valid">   
            <v-layout xs12 row wrap>
              <v-flex xs12>
                <v-text-field
                  required
                  :error-messages="sellerIdErrors"
                  color="indigo"
                  label="Amazon Seller Id"
                  v-model="seller_id"
                  prepend-icon="person"
                  @input="$v.seller_id.$touch()"
                  @blur="$v.seller_id.$touch()"
                ></v-text-field>
              </v-flex>
              
              <v-flex xs12>
                <v-select
                  required
                  :items="marketplaces"
                  label="Select your Amazon Marketplace"
                  :error-messages="marketplaceErrors"
                  v-model="selected_marketplace"
                  color="indigo"
                  prepend-icon="map"
                  @input="$v.selected_marketplace.$touch()"
                  @blur="$v.selected_marketplace.$touch()"                  
                ></v-select>
              </v-flex>

              <v-flex xs12>
                <v-text-field
                  required
                  color="indigo"
                  id="testing"
                  name="input-1"
                  label="Amazon Auth Token"
                  :error-messages="tokenErrors"
                  v-model="token"
                  prepend-icon="https"
                  @input="$v.token.$touch()"
                  @blur="$v.token.$touch()"                      
                ></v-text-field>
              </v-flex>

              <v-flex xs12>
                <v-select
                  required
                  color="indigo"
                  :items="zones"
                  label="Select which zone(s) you would like to add this rate too"
                  :error-messages="zoneErrors"
                  v-model="selected_zones"
                  prepend-icon="public"
                  multiple
                  chips
                  deletable-chips
                  @input="$v.selected_zones.$touch()"
                  @blur="$v.selected_zones.$touch()" 
                ></v-select>
              </v-flex>
            
              <v-layout row wrap class="text-xs-center" v-if="show_cancel_button">
                <v-flex xs6>
                  <v-btn block large class="my_dark_purple_btn" dark @click="formCheckAndSend()">Update Your Credentials</v-btn>
                </v-flex>
                <v-flex xs6>
                  <v-btn block outline large color="indigo" dark @click="sendBackToSpeeds">Cancel</v-btn>
                </v-flex>
              </v-layout>
            
              <v-layout row wrap class="text-xs-center" v-else>
                <v-flex xs12>
                  <v-btn block large class="my_dark_purple_btn" dark @click="formCheckAndSend()">Save Your Credentials</v-btn>
                </v-flex>
              </v-layout>  
              
              </v-layout>
            </v-form>
          </v-card>
        </v-flex>
        
        <div class="text-xs-center">
          <v-bottom-sheet inset v-model="error_sheet">
            <v-card dark color="red darken-1">
              <v-card-title>
                <h1 v-if="credentials_bad" key="bad_creds" class="headline pb-2 oswald mx-auto">{{bad_credentials}}</h1>
                <h1 v-if="credentials_bad" key="video" class="title oswald mx-auto">{{watch_video}}</h1>
              </v-card-title>
            </v-card>  
          </v-bottom-sheet>
        </div>
  
      </v-layout>
    </v-container>
</template>

<script>
import {dataShare} from '../packs/application.js';
import axios from 'axios';
import { required } from 'vuelidate/lib/validators';

export default {
  validations: {
      seller_id: { required },
      selected_marketplace: { required },
      token: { required },
      selected_zones: { required }
    },
  data: function() {
    return {
      show_cancel_button: true,
      credentials_bad: false,
      bad_credentials: "Oh no! Your Amazon credentials aren't right. Can you try again?",
      watch_video: "Make sure to watch our video in the top right hand corner",
      valid: true,
      error_sheet: false,
      seller_id: '',
      token: "",
      selected_zones: [],
      selected_marketplace: null,
      counter: 1,
      subtractor: 1,
      wrapCounter: 1,
      zones: [],
      marketplaces:[
          { text: 'Australia', value: "A39IBJ37TRP1C6" },
          { text: 'Canada', value: "A2EUQ1WTGCTBG2" },
          { text: 'France', value: "A13V1IB3VIYZZH" },
          { text: 'Germany', value: "A1PA6795UKMFR9" },
          { text: 'Italy', value: "APJ6JRA9NG5V4" },
          { text: 'Mexico', value: "A1AM78C64UM0Y8" },
          { text: 'Spain', value: "A1RKKUPIHCS9HS" },
          { text: 'United Kingdom', value: "A1F83G8C2ARO7P" },
          { text: 'United States', value: "ATVPDKIKX0DER" },          
        ],
    };
  },
  created() {
    let self = this;
    axios.get('https://bc-ship-trimakas.c9users.io/return_zone_info').then(response => {
      response.data.forEach(function(zone) {
        if(zone.selected){
          var zone_selected_hash = {text: zone.zone_name, value: zone.bc_zone_id};
          self.selected_zones.push(zone_selected_hash); 
        }
        var zone_hash = {text: zone.zone_name, value: zone.bc_zone_id};
        self.zones.push(zone_hash);
      });
    });
    axios.get('https://bc-ship-trimakas.c9users.io/return_amazon_credentials').then(response => {
      this.seller_id = response.data.seller_id;
      if(this.seller_id == ""){
        this.show_cancel_button = false;
      }
      this.show_cancel_button;
      this.selected_marketplace = response.data.marketplace;      
      this.token = response.data.auth_token;
    });
  },
  computed: {
    sellerIdErrors() {
      const errors = []
      if (!this.$v.seller_id.$dirty) return errors
      !this.$v.seller_id.required && errors.push('Please enter your Amazon Seller Id')
      return errors      
    },
    marketplaceErrors() {
      const errors = []
      if (!this.$v.selected_marketplace.$dirty) return errors
      !this.$v.selected_marketplace.required && errors.push('Please select your Amazon Marketplace')
      return errors      
    },
    tokenErrors() {
      const errors = []
      if (!this.$v.token.$dirty) return errors
      !this.$v.token.required && errors.push('Please enter your Amazon Auth Token')
      return errors      
    },
    zoneErrors() {
      const errors = []
      if (!this.$v.selected_zones.$dirty) return errors
      !this.$v.selected_zones.required && errors.push('Please choose atleast one shipping zone to add this rate too')
      return errors      
    },      
  },
  methods: {
    formCheckAndSend () {
      if(this.$refs.form.validate()) {
        this.sendAmazonCreds();
      }
    },
    sendBackToSpeeds() {
      dataShare.$emit('whereToGo', "speeds");
    },
    removeCounter() {
      dataShare.$emit('removeComponent', this.subtractor);
    },
    addCounter() {
      this.counter++;
      dataShare.$emit('addComponent', this.counter);
      var allWraps = document.getElementsByClassName("application--wrap");
      var classToRemove = allWraps[this.wrapCounter];
      classToRemove.classList.remove("application--wrap");
      this.wrapCounter++;
    },
    sendAmazonCreds() {
      const AmazonCreds = {
        seller_id: this.seller_id,
        marketplace: this.selected_marketplace,
        auth_token: this.token,
      };
      let self = this;
      axios.post('https://bc-ship-trimakas.c9users.io/amazon_credentials_check', AmazonCreds).then(response => {
        var creds_status = response.data.are_the_amazon_creds_good;
        if(creds_status == true){
          dataShare.$emit('whereToGo', "speeds");
          this.sendZones();
        }
        if(creds_status == false){
          self.error_sheet = true;
          self.credentials_bad = true;
        }
      });
    },
    sendZones() {
        const SelectedZones = {
          zone_info: this.selected_zones
        };
        axios.post('https://bc-ship-trimakas.c9users.io/receive_zone_info', SelectedZones); 
    }
  }
};  

</script>

<style>

  .chip__content {
    background-color: #273a8a !important;
    color: white !important;
  }

  .come_closer {
     margin-top: -15px !important; 
  }
</style>