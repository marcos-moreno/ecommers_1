<template> 
<div>
    <app-menu/> 
      <!-- <v-toolbar>    
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
      </v-toolbar> -->

<v-card color="basil">
    <v-card-title class="text-center justify-center py-6">
      <h3 class="font-weight-bold text-h3 basil--text">
        Ayuda
      </h3>
    </v-card-title>

    <v-tabs
      v-model="tab"
      background-color="transparent"
      color="basil"
      grow
    >
      <v-tab>
              Aromas
            </v-tab>   
            <v-tab>
              Preguntas frecuentes
            </v-tab> 
    </v-tabs>

    <!-- <v-tabs-items v-model="tab">
      <v-tab-item
        v-for="item in items"
        :key="item"
      >
        <v-card
          color="basil"
          flat
        >
 
        </v-card>
      </v-tab-item>
    </v-tabs-items> -->
  </v-card>


    <v-card min-height="800px"> 
      <ForoAromas v-if="tab==0" /> 
      <PreguntasFrecuentes v-if="tab==1" />
    </v-card> 
</div>
</template>  
 
 <style>
/* Helper classes */
.basil {
  /* background-color: #FFFBE6 !important; */
  background-color: #FFF !important;
}
.basil--text {
  color: #356859 !important;
}
</style>

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
