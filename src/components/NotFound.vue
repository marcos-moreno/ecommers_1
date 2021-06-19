<template>
  <div>
    <app-menu/> 
    <v-container class="mx-auto text-center" style="min-height:706px;">
      <br><br><br>
      <!-- width="280" -->
      <img width="80%" src="http://refividrio.com.mx/ecommerce/mantenimiento.png">
      
      <p style="font-size: 2em;color :#909090">  
        <strong>La página que buscas aún no esta disponible.</strong> 
      </p>
    </v-container>
  </div>
</template> 
<script> 
import AppMenu from '../components/Menu.vue';

export default { 
  data() {
    return {  
    }; 
  }, 
  components: {  
    'app-menu': AppMenu, 
  }
}
</script> 
