<template>
  <v-app>
    <credential_instructions class="no_background"></credential_instructions>
    <credential_details
      xs12
      class="no_background"
      id="amazon_credentials"
      v-for="(item, index) in components"
      :index="index"
      :key="'fourth' + index "
      ></credential_details>
  </v-app>  
</template>

<script>
/*global top*/

import {dataShare} from '../packs/application.js';
import credential_instructions from '../components/credential_instructions.vue';
import credential_details from '../components/credential_details.vue';
import axios from 'axios';

export default {
  data: function() {
    return {
      components: [1],
    };
  },
  components: {
    credential_instructions,
    credential_details
  },
  created() {
    dataShare.$on('addComponent', (data) => {
      this.components.push(data);
    });
    dataShare.$on('removeComponent', (data) => {
      this.components.pop();
    });
  },
  methods: {
    sendToBilling() {
      axios.post('https://new-ship-trimakas.c9users.io/create_billing_plan').then(response => {
        console.log(response.data);
        top.location.href = response.data.url_redirect;
      });
    }
  }
};  

</script>

<style>

.dark-green-button {
  background-color: #43A047 !important;
}

.green-font {
  color: #43A047 !important;
}

.red-font {
  color: #E53935 !important;
}

.full-height .flex{
  display: flex !important; 
}

.full-height .flex > .card{
 flex: 1 1 auto !important; 
}
    

.textfield-background-beige {
  background-color: #f7f1ec !important;
}

.theme--light .input-group input:disabled {
  color: rgba(0,0,0,.87) !important;
}
  
.lightbeige {
  background-color: #f1e7df !important;
}

.lightblue {
  background-color: #d9d6e1 !important;
}

.lightpurple {
  background-color: #e9daea !important;
}

.match-to-text-field {
  margin-left: -17px !important;
  height: 46px !important;
  margin-top: 1px !important;
}
</style>