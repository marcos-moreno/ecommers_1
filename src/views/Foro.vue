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
              Aromas
            </v-tab>   
            <v-tab>
              Preguntas frecuentes
            </v-tab> 
            </v-tabs>  
          </v-tabs> 
      </v-toolbar> 
    <v-card min-height="800px"> 
      <ForoAromas v-if="tab==0" />
      <PreguntasFrecuentes v-if="tab==1" />
    </v-card> 
</div>
</template>  
 
<script> 
import AppMenu from '../components/Menu.vue';
import ForoAromas from '../components/ForoAromas.vue';
import PreguntasFrecuentes from '../components/PreguntasFrecuentes.vue';

 
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
        PreguntasFrecuentes,
        ForoAromas
  },methods: { }    
}
</script>
