<template>
 <v-app>
   <app-slider/>  
    <v-main class="grey lighten-2">
      <v-container>
        <v-row>
            <products-index/>
        </v-row>
      </v-container>
    </v-main> 
  </v-app>

</template>

<script>
  import ProductsIndex from '../components/ProductsIndex'; 
  import AppSlider from '../components/Slider'; 
  export default {
    components: {
      'products-index': ProductsIndex, 
      'app-slider': AppSlider, 
    }
  } 
</script>