<template>
  <div>
    <app-menu/> 
    <v-container class="mx-auto text-center" style="min-height:706px;">
      <br><br><br> 
      <p style="font-size: 1em;color :#909090">  
       <strong>CAPACITACIÓN AROMAS DE ANDALUCÍA.</strong> 
      </p>
      <iframe
      width="560" height="349"
        src="https://refividrio.com.mx/EcommerceDistribuidor/Videos/CAPACITACIÓNAROMASDEANDALUCIA.mp4" 
        frameborder="0" allowfullscreen="allowfullscreen">
      </iframe>
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
