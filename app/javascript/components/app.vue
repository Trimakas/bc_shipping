<template>
  <v-app class="my_background">
      <transition leave-active-class="animated slideOutLeft"  enter-active-class="animated slideInRight" mode="out-in">
        <component class="no_background" 
          :is="selected"
          transition="animated slideOutLeft"  
          mode="out-in"
        ></component>
      </transition>
  </v-app>
</template>

<script>
import welcome from '../components/welcome.vue';
import one from '../components/step_1.vue';
import two from '../components/step_2.vue';
import amazon_credentials from '../components/amazon_credentials.vue';
import speeds from '../components/speeds.vue';
import 'images/background.png';
import {dataShare} from '../packs/application.js';
import axios from 'axios';

export default {
  data: function() {
    return{
      selected: 'welcome'
    };
  },
  components: {
    welcome,
    one,
    two,
    amazon_credentials,
    speeds
  },
  created() {
    axios.get('https://bc-ship-trimakas.c9users.io/where_to_send_user').then(response => {
      this.selected = response.data;
    });
    dataShare.$on('whereToGo', (whereToGo) => {
      this.selected = whereToGo;
    });
  }
};

</script>

<style>

html {
    height: 100%;
}

body {
    margin: 0;
    min-height: 100%;
    overflow: hidden;
}

.no_background {
  background: none !important;
}

.my_background {
  background-image: url('../images/background.png') !important;
  background-position: center !important;
  background-repeat: no-repeat !important;
  background-size: cover !important;
}

</style>