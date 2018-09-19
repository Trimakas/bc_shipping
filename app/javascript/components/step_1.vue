<template>
  <v-app>
    <v-container text-xs-center >
      <v-layout row wrap align-center>
        <v-flex xs6 offset-xs3>
          <h1 class="display-1 sans_pro_medium my_dark_purple_text my-4">FBA Shipping</h1>
          <div class="filled_dot mx-2 mt-3"></div>
          <div class="dot mx-2"></div>
          <div class="dot mx-2"></div>
          <v-spacer></v-spacer>
            <v-card>
              <v-card-text class="sans_pro card_text_fix">
              FBA Shipping by ByteStand fulfills an unlimited number of orders, so you don't have too. 
              We take care of you and your customers by fulfilling your FBA items thru Amazon. 
              Once an order is fulfilled by Amazon we then notify your customers when the order ships and provide all tracking info from Amazon.
              </v-card-text>
            </v-card>
        </v-flex>
        
        <v-flex xs1 class="text-xs-right mx-auto my-5">
          <v-spacer class="mt-5"></v-spacer>
          <v-btn outline fab dark large color="indigo" class="mt-5" @click="sendToStepTwo">
            <v-icon dark size="60px" class="my_dark_purple_text">chevron_right</v-icon>
          </v-btn>
        </v-flex>
        
      </v-layout>
    </v-container>
  </v-app>  
</template>

<script>
import {dataShare} from '../packs/application.js'

export default {
  data: function() {
    return {
      whereToGo: "two"
    }
  },
  methods: {
    sendToStepTwo() {
      dataShare.$emit('whereToGo', this.whereToGo);
    }
  },
};  
</script>

<style>
.btn.btn--outline {
  border: 1px solid #273a8a !important;
}

.card_text_fix {
  line-height: 1.3 !important;
  font-size: 20px!important;
  font-weight: 500;
  letter-spacing: .02em!important;
}

.card {
  border-radius: 5px !important;
  padding: 15px !important;
}  
  
</style>