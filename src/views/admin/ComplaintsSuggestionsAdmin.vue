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
            <v-tabs v-model="tab" background-color="secondary" color="basil" grow dark >

            <v-tab>
              Quejas y Sugerencias
            </v-tab>   
 
            </v-tabs>  
          </v-tabs> 
      </v-toolbar> 
    <v-card min-height="800px"> 
      <QuejaSugerenciaAdmin v-if="tab==0" />
    </v-card> 
</div>
</template>  
 
<script> 
import AppMenu from '../../components/admin/MenuAdmin.vue';
import QuejaSugerenciaAdmin from '../../components/admin/QuejaSugerenciaAdmin.vue';

 
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
        QuejaSugerenciaAdmin
  },methods: { }    
}
</script>
