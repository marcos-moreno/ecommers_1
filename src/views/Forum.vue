<template> 
<div>
    <app-menu/> 
      <v-toolbar>    
          <v-tabs v-model="tab"
            next-icon="mdi-arrow-right-bold-box-outline"
            prev-icon="mdi-arrow-left-bold-box-outline"
            show-arrows
           >
            <v-tabs-slider color="yellow"></v-tabs-slider> 
            <v-tabs v-model="tab" background-color="primary" color="basil" grow dark >
            <v-tab>
              Preguntas
            </v-tab>
            </v-tabs>  
          </v-tabs> 
      </v-toolbar> 
    <v-card min-height="800px"> 
      <PreguntaRespuesta v-if="tab==0" />
    </v-card> 
</div>


</template>  
 
<script> 
import AppMenu from '../components/Menu.vue';
import PreguntaRespuesta from '../components/PreguntaRespuesta.vue';

 
export default {
  name: "HomeAdmin",  
  data() {
    return { 
      tab : "",
      verfiltro : false
    }; 
  },  
  async created() {   
  },
  components: { 
        'app-menu': AppMenu, 
        PreguntaRespuesta
  },methods: { }    
}
</script>
