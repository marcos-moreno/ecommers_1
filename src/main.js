import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify';
import VueCookie from 'vue-cookie'; 
import ZoomOnHover from "vue-zoom-on-hover";

Vue.config.productionTip = false
Vue.use(VueCookie); 
Vue.use(ZoomOnHover); 

new Vue({
  router,
  vuetify,
  render: h => h(App)
}).$mount('#app')
