<template>
  <div>
    <v-card flat class="lightblue" :resize="moveIcon">
      <v-form ref="form" v-model="valid" lazy-validation>   
        
        <v-layout row wrap>
          <v-flex xs7>
            <v-switch 
              label="Enable Standard Shipping"
              v-model="standard_speed_enabled"
              color="indigo"
              @change="enableAndDisable"
              ></v-switch>
          </v-flex>
        </v-layout>
  
        <v-layout row wrap>
          <v-flex xs7>
            <v-switch 
              label="Enable Flex Rate Shipping?" 
              :disabled="standard_flex_switch_disabled" 
              v-model="standard_flex_enabled" 
              color="indigo"
              @change="killFixed, removeFlexAmount"
              ></v-switch>
          </v-flex>
          <v-flex>
            <v-tooltip top>
              <v-icon slot="activator" color="indigo" class="fix_icon">info</v-icon>
              <span class="body-2">You can enable fixed or flex rate shipping but not both</span>
            </v-tooltip>
          </v-flex>
        </v-layout>
        
        <v-layout row wrap class="move-up">
           <v-flex xs1>
            <v-select
              :disabled="!standard_flex_enabled"
              append-icon=""
              color="indigo"
              :items="standard_fee_type"
              v-model="standard_percent_or_dollar"
              :label="standard_currency_symbol + ' or %'"
              single-line
              auto
              hide-details
            ></v-select>
          </v-flex>
          
          <v-flex xs8>                      
            <v-text-field
              :disabled="!standard_flex_enabled"
              type="number"
              color="indigo"
              label="Shipping Amount Above or Below FBA Fees"
              v-model="standard_flex_above_or_below_amount"
              class="push-right"
            ></v-text-field>
          </v-flex>
          <v-flex xs1 v-bind="standard_icon_adjust" class="push_down">
            <v-tooltip top>
                <v-icon slot="activator" color="indigo" class="fix_icon">info</v-icon>
                <span class="body-2">This amount will either increase or decrease(-) the fulfillment amount from Amazon.
                </span>
              </v-tooltip>
          </v-flex>
        </v-layout>
  
        <v-layout row wrap>                    
          <v-flex xs7>
            <v-switch 
            label="Enable Fixed Rate Shipping?" 
            :disabled="standard_fixed_switch_disabled" 
            v-model="standard_fixed_enabled" 
            color="indigo"
            @change="killFlex, removeFixedAmount"
            ></v-switch>
          </v-flex>
          <v-flex xs1>
            <v-tooltip top>
                <v-icon slot="activator" color="indigo" class="fix_icon_less">info</v-icon>
                <span class="body-2">This amount will be displayed to your customer and Amazon fees will be ignored.
                </span>
              </v-tooltip>
          </v-flex>
        </v-layout>
        
        <v-layout row wrap>
          <v-flex xs4>                      
            <v-text-field
              :disabled="!standard_fixed_enabled"
              type="number"
              color="indigo"
              label="Fixed Rate Amount"
              v-model="standard_fixed_rate_amount"
              :prefix="standard_currency_symbol"
              class="move-up"
            ></v-text-field>
           </v-flex>
        </v-layout>
        
        <v-layout row wrap>
          <v-flex xs7>
            <v-switch label="Enable Free Shipping?" :disabled="!standard_speed_enabled" v-model="standard_free_enabled" color="indigo"></v-switch>
          </v-flex>
        </v-layout>
        
        <v-layout row wrap>                    
          <v-flex xs8>                      
            <v-text-field
              :disabled="!standard_free_enabled"
              type="number"
              color="indigo"
              label="Order Amount to Qualify for Free Shipping"
              v-model="standard_free_shipping_amount"
              class="move-up"
              :prefix="standard_currency_symbol"
              @change="removeFreeAmount"
            ></v-text-field>
          </v-flex>
        </v-layout>
        
        <v-layout row wrap>
          <v-flex xs11>
            <v-btn 
              medium 
              dark 
              color="indigo"
              @click="sendShipping"
              >Save Standard Settings</v-btn>
              
            <v-btn 
              medium 
              outline 
              color="indigo"
              @click="deleteShipping"
              >Delete Standard Settings</v-btn>
          </v-flex>                      
        </v-layout>                    
      </v-form>  
    </v-card>
    
    <div class="text-xs-center">
      <v-bottom-sheet inset v-model="standard_success_sheet">
        <v-card dark color="green darken-1">
          <v-card-title>
            <h1 v-if="standard_success_sheet" key="good_job" class="headline pb-2 oswald mx-auto">Good job! You just saved your standard shipping rates!</h1>
          </v-card-title>
        </v-card>  
      </v-bottom-sheet>
    </div>
    
    <div class="text-xs-center">
      <v-bottom-sheet inset v-model="standard_delete_sheet">
        <v-card dark color="red darken-1">
          <v-card-title>
            <h1 v-if="standard_delete_sheet" key="good_delete" class="headline pb-2 oswald mx-auto">Easy peasy. You just deleted your standard shipping rate!</h1>
          </v-card-title>
        </v-card>  
      </v-bottom-sheet>
    </div>
    
    <div class="text-xs-center">
      <v-bottom-sheet inset v-model="standard_turned_off_sheet">
        <v-card dark color="red darken-1">
          <v-card-title>
            <h1 v-if="standard_turned_off_sheet" key="good_turn_off" class="headline pb-2 oswald mx-auto">All Good. You just turned off your standard shipping rate!</h1>
          </v-card-title>
        </v-card>  
      </v-bottom-sheet>
    </div>
    
  </div>  
</template>

<script>
/*global localStorage*/
import {dataShare} from '../packs/application.js';
import axios from 'axios';

var url = "https://bc-shipping.bytestand.com";

export default {
  data: function() {
    return {
      success_sheet: false,
      standard_turned_off_sheet: false,
      standard_success_sheet: false,
      standard_delete_sheet: false,
      
      speed: "Standard",
      standard_icon_adjust: {'offset-xs1': false},
      standard_icon_push_right: {'push-right': false},

      standard_speed_enabled: false,
      standard_flex_enabled: false,
      standard_fixed_enabled: false,  
      standard_free_enabled: false,
      
      standard_flex_switch_disabled: true,
      standard_fixed_switch_disabled: true,
      
      standard_fixed_rate_amount: "",
      standard_free_shipping_amount: "",
      standard_flex_above_or_below_amount: "",
      valid: true,

      standard_percent_or_dollar: "",
      standard_fee_type: ["", "%"],
      
      standard_currency_symbol: ""
    };
  },
  created() {
    dataShare.$on('success_sheet', (success_sheet) => {
      this.success_sheet = success_sheet;
    });
    axios.get(url + '/return_speed_info', {params: {speed: this.speed}}).then(response => {
      if(response.data.shipping_speed == "Standard" && response.data.enabled == true){
        this.standard_speed_enabled = true;
      }
      else{
        this.standard_speed_enabled = false;
      }
      this.standard_fixed_rate_amount = response.data.fixed_amount;
      this.standard_fixed_enabled = response.data.fixed;
      this.standard_flex_enabled = response.data.flex;
      this.standard_flex_above_or_below_amount = response.data.flex_amount;
      this.standard_percent_or_dollar = response.data.flex_dollar_or_percent;
      this.standard_free_enabled = response.data.free;
      this.standard_free_shipping_amount = response.data.free_shipping_amount;
      this.enableAndDisable();
    });
    axios.get(url + '/return_currency_info').then(response => {
      this.standard_currency_symbol = response.data.currency_symbol;
      this.standard_fee_type = [this.standard_currency_symbol, "%"];
    });
  },
  computed: {
    enableAndDisable(){
      if(this.standard_speed_enabled == true){
        this.standard_flex_switch_disabled = false;
        this.standard_fixed_switch_disabled = false;
      }
      if(this.standard_speed_enabled == false){
        this.standard_flex_switch_disabled = true;
        this.standard_fixed_switch_disabled = true;
        this.standard_flex_enabled = false;
        this.standard_fixed_enabled = false;  
        this.standard_free_enabled = false;
        this.standard_fixed_rate_amount = "";
        this.standard_free_shipping_amount = "";
        this.standard_flex_above_or_below_amount = "";
        this.standard_percent_or_dollar = "";
      }
    },
    removeFlexAmount(){
      if(this.standard_flex_enabled == false){
        this.standard_flex_above_or_below_amount = "";
        this.standard_percent_or_dollar = "";
      }
    },
    removeFixedAmount(){
      if(this.standard_fixed_enabled == false){
        this.standard_fixed_rate_amount = "";
      }
    },
    removeFreeAmount(){
      if(this.standard_free_enabled == false){
        this.standard_free_shipping_amount = "";
      }
    },
    pushIconRight() {
    if(this.$vuetify.breakpoint.mdAndDown){
      this.standard_icon_push_right['push-right'] = true;
    }
    else{
      this.standard_icon_push_right['push-right'] = false;
    }
    },
    moveIcon() {
    console.log(this.$vuetify.breakpoint.name);
    if(this.$vuetify.breakpoint.mdAndDown){
      this.standard_icon_adjust['offset-xs1'] = true;
    }
    else{
      this.standard_icon_adjust['offset-xs1'] = false;
    }
    },
    killFixed(){
      if(this.standard_flex_enabled == true){
        this.standard_fixed_switch_disabled = true;
        this.standard_fixed_rate_amount = "";
      }
      if(this.standard_speed_enabled == true && this.standard_flex_enabled == true){
        this.standard_fixed_switch_disabled = true;
        this.standard_fixed_enabled = false;
        this.standard_fixed_rate_amount = "";
        
      }
      if(this.standard_speed_enabled == true && this.standard_flex_enabled == false){
        this.standard_fixed_switch_disabled = false;
      }
    },
    killFlex(){
      if(this.standard_fixed_enabled == true){
        this.standard_flex_switch_disabled = true;
        this.above_or_below_amount = "";
      }
      if(this.standard_speed_enabled == true && this.standard_fixed_enabled == true){
        this.standard_flex_switch_disabled = true;
        this.standard_flex_enabled = false;
        this.above_or_below_amount = "";
        this.standard_percent_or_dollar = "";
        
      }
      if(this.standard_speed_enabled == true && this.standard_fixed_enabled == false){
        this.standard_flex_switch_disabled = false;
      }
    }  
    },
    methods: {
      sendShipping() {
        this.standard_success_sheet = true;
        const shipping = {
          speed_type: this.speed,
          speed_enabled: this.standard_speed_enabled,
          flex_enabled: this.standard_flex_enabled,
          fixed_enabled: this.standard_fixed_enabled,  
          free_enabled: this.standard_free_enabled,
          fixed_rate_amount: this.standard_fixed_rate_amount,
          free_shipping_amount: this.standard_free_shipping_amount,
          flex_above_or_below_amount: this.standard_flex_above_or_below_amount,
          percent_or_dollar: this.standard_percent_or_dollar
        };
        let self = this;
        let speed_info = {bytestand_rate_info: shipping};
        axios.post(url + '/save_shipping_info', speed_info).then(response => {
          console.log(this.response);
        });
      },
      deleteShipping() {
        this.standard_delete_sheet = true;
        this.standard_speed_enabled = false;
        this.standard_fixed_rate_amount = "";
        this.standard_fixed_enabled = false;
        this.standard_flex_enabled = false;
        this.standard_flex_above_or_below_amount = "";
        this.standard_percent_or_dollar = "";
        this.standard_free_enabled = false;
        this.standard_free_shipping_amount = "";
        const deleteSpeed = {
          speed_type: this.speed          
        };
        let self = this;
        let delete_speed = {bytestand_rate_info: deleteSpeed};
        axios.post(url + '/delete_speed', delete_speed).then(response => {
          console.log(this.response);
        });       
      }
    }
};
</script>

<style>

.push_down {
  margin-top: 18px;
}

.fix_icon_less {
  margin-top: 5px;
  margin-left: -70px;
}


.fix_icon {
  margin-top: 5px;
  margin-left: -80px;
}
.move-up {
  margin-top: -18px;
}

.move-left {
  margin-left: -20px;
}

.push-right {
  margin-left: 10px;
}
  
</style>