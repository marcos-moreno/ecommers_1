<template>
  <v-app id="inspire">   
    <app-menu/>  
    <router-view/>  
    <app-footer/>  
  </v-app>
</template>

<script>
  import AppFooter from './components/Footer.vue'; 
  import AppMenu from './components/Menu.vue';

  export default {
    data: () => ({ 
    }),
    components: {
      'app-footer': AppFooter, 
      'app-menu': AppMenu, 
    },created(){
    }
  }
</script>