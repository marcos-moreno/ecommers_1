import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify';


import Vuesax from 'vuesax'
import 'vuesax/dist/vuesax.css';
// import 'material-icons/iconfont/material-icons.css';

Vue.config.productionTip = false

Vue.use(Vuesax);

new Vue({
  router,
  vuetify,
  render: h => h(App)
}).$mount('#app')
