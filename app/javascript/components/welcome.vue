<template>
  <v-app>  
    <v-container fill-height>
      <v-layout row wrap align-center class="text-xs-center">
        <v-flex align-center xs6 v-show="['lg', 'xl'].includes(size)" class="mx-auto">
          <v-jumbotron flex :height="imageHeight" :width="imageHeight" src="rose.png">
            <v-container fill-height>
              <v-layout align-center>
                <v-flex xs12 text-xs-center>
                  <v-spacer class="mb-4"></v-spacer>
                  <h1 class="display-1 sans_pro my_light_purple_text mt-3">Welcome to</h1>
                  <h1 class="display-2 my_dark_purple_text sans_pro_medium">FBA Shipping</h1>
                  <h1 class="title sans_pro mt-2">A super simple way to automate </h1>
                  <h1 class="title sans_pro">fulfilling FBA items in the</h1>
                  <h1 class="title sans_pro">US and abroad.</h1>
                  <v-btn @click="sendToStepOne" large class="mt-3 my_dark_purple_btn sans_pro">Let's Get Started!</v-btn>                  
                </v-flex>
              </v-layout>
            </v-container>
          </v-jumbotron>
        </v-flex>
        
        <v-flex align-center xs6 v-show="['md'].includes(size)" class="mx-auto">
          <v-jumbotron flex :height="imageHeight" :width="imageHeight" src="rose_400.png">
            <v-container fill-height>
              <v-layout align-center>
                <v-flex xs12 text-xs-center>
                  <v-spacer class="mb-4"></v-spacer>
                  <h1 class="headline sans_pro my_light_purple_text mt-3">Welcome to</h1>
                  <h1 class="display-1 my_dark_purple_text sans_pro_medium">FBA Shipping</h1>
                  <h1 class="body-2 sans_pro mt-2">A super simple way to automate </h1>
                  <h1 class="body-2 sans_pro">fulfilling FBA items in the</h1>
                  <h1 class="body-2 sans_pro">US and abroad.</h1>
                  <v-btn @click="sendToStepOne" large class="mt-3 my_dark_purple_btn">Let's Get Started!</v-btn>
                </v-flex>
              </v-layout>
            </v-container>
          </v-jumbotron>
        </v-flex>
        
        <v-flex align-center sm8 xs12 v-show="['sm', 'xs'].includes(size)" class="mx-auto">
          <v-jumbotron flex :height="imageHeight" :width="imageHeight" src="rose_325.png">
            <v-container fill-height>
              <v-layout align-center>
                <v-flex text-xs-center>
                  <h1 class="headline sans_pro my_light_purple_text mt-3">Welcome to</h1>
                  <h1 class="display-1 my_dark_purple_text sans_pro_medium">FBA Shipping</h1>
                  <h1 class="body-1 sans_pro mt-2">A super simple way to automate </h1>
                  <h1 class="body-1 sans_pro">fulfilling FBA items in the</h1>
                  <h1 class="body-1 sans_pro">US and abroad.</h1>
                  <v-btn @click="sendToStepOne" small class="mt-1 my_dark_purple_btn">Let's Go!</v-btn>
                </v-flex>
              </v-layout>
            </v-container>
          </v-jumbotron>
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
      size: "",
      whereToGo: "one"
    }
  },
  methods: {
    sendToStepOne() {
      dataShare.$emit('whereToGo', this.whereToGo);
    }
  },
  computed: {
    imageHeight() {
      console.log("the screen size is " + this.$vuetify.breakpoint.name);
      this.size = this.$vuetify.breakpoint.name;
      switch (this.size) {
        case 'xs': return '450px';
        case 'sm': return '475px';
        case 'md': return '500px';
        case 'lg': return '540px';
        case 'xl': return '540px';
     }
   },
  }
};

</script>

<style>

.filled_dot {
  height: 20px;
  width: 20px;
  border-color: #273a8a;
  border-style: solid;
  border-width: 2px;
  background-color: #273a8a;
  border-radius: 50%;
  display: inline-block;
}


.dot {
  height: 20px;
  width: 20px;
  border-color: #273a8a;
  border-style: solid;
  border-width: 2px;
  border-radius: 50%;
  display: inline-block;
}

.spacer {
  padding-top: 20px;
  padding-bottom: 20px;
}

.sans_pro_light {
  font-family: 'Source Sans Pro', sans-serif !important;
  font-weight: 300 !important;
}

.sans_pro {
  font-family: 'Source Sans Pro', sans-serif !important;
  font-weight: 400 !important;
}

.sans_pro_medium {
  font-family: 'Source Sans Pro', sans-serif !important;
  font-weight: 600 !important;
}

.sans_pro_bold {
  font-family: 'Source Sans Pro', sans-serif !important;
  font-weight: 700 !important;
}

.no_background {
  background: transparent !important;
}

.my_dark_purple_btn {
  background-color: #273a8a !important;
  color: white !important;
}

.my_dark_purple_text {
  color: #273a8a !important;
}

.my_light_purple_text {
  color: #3e5ed6 !important;
}

</style>