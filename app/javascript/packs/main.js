import Vue from 'vue'
import axios from 'axios'
import App from '../app.vue'
import router from '../router';
import store from '../store';
// import Icon from 'vue-awesome/components/Icon';
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";

import '@mdi/font/css/materialdesignicons.css'
import '@fortawesome/fontawesome-free/css/all.css'

Vue.use(Vuetify);
const vuetify = new Vuetify({
  icons: {
    iconfont: 'mdi',
    iconfont: 'fa',
  },
});
Vue.config.productionTip = false
axios.defaults.baseURL = 'http://localhost:3001'
// Vue.component('v-icon', Icon)
document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello'))
  const app = new Vue({
    router,
    store,
    vuetify,
    el,
    render: h => h(App)
  })
})