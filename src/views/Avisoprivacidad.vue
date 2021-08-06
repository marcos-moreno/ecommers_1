<template>
    <div>  
        <app-menu/>
        <v-container>
            <Avisoprivacidad/>
        </v-container>
    </div>
</template>
 
<script>   
import AppMenu from '../components/Menu.vue'; 
import Avisoprivacidad from '../components/AvisoPrivacidadpr.vue'; 
export default {
  name: "AvisoPrivacidad",
  data() {
    return {}
  }, 
  created(){
      window.scrollTo(0,0);
  },mounted(){
      window.scrollTo(0,0);
  } 
  ,methods: { 
   
  },  
  components: {
    AppMenu,Avisoprivacidad
  }
}
</script>
